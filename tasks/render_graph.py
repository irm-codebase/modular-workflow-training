"""Render Snakemake rule graphs and simplified module graphs."""

import subprocess
import sys
import tempfile
from pathlib import Path

import click
import networkx as nx
from clio_tools.data_module import modular_rulegraph_png


def rulegraph_dot(target: str) -> str:
    """Return a Snakemake rule graph in DOT format."""
    command = ["snakemake", "--rulegraph=dot"]
    if target:
        command.append(target)

    result = subprocess.run(command, capture_output=True, check=False, text=True)
    if result.stderr:
        sys.stderr.write(result.stderr)
    if result.returncode:
        raise SystemExit(result.returncode)
    if not result.stdout.lstrip().startswith("digraph"):
        raise click.ClickException("Snakemake did not produce a DOT rule graph.")
    return result.stdout


def left_to_right(dot: str) -> str:
    """Set a DOT graph's layout direction to left-to-right."""
    return dot.replace("{", "{\n    rankdir=LR;", 1)


def render_rulegraph(dot: str, output: Path) -> None:
    """Render a DOT rule graph as a PNG file."""
    result = subprocess.run(
        ["dot", "-Tpng", "-o", str(output)],
        input=left_to_right(dot),
        capture_output=True,
        check=False,
        text=True,
    )
    if result.stderr:
        sys.stderr.write(result.stderr)
    if result.returncode:
        raise SystemExit(result.returncode)


def replace_cross_module_edges(dot_path: Path, prefixes: list[str]) -> None:
    """Replace rule edges between modules with module-to-module edges."""
    rulegraph = nx.DiGraph(nx.nx_pydot.read_dot(dot_path))
    labels = nx.get_node_attributes(rulegraph, "label")
    node_prefixes = {
        node: next(
            (prefix for prefix in prefixes if label.strip('"').startswith(prefix)), None
        )
        for node, label in labels.items()
    }

    module_edges = set()
    for source, destination in list(rulegraph.edges):
        source_prefix = node_prefixes.get(source)
        destination_prefix = node_prefixes.get(destination)
        if (
            source_prefix is not None
            and destination_prefix is not None
            and source_prefix != destination_prefix
        ):
            rulegraph.remove_edge(source, destination)
            module_edges.add((source_prefix, destination_prefix))

    rulegraph.add_edges_from(module_edges)
    nx.nx_pydot.write_dot(rulegraph, dot_path)


def render_modulegraph(dot: str, output: Path, prefixes: list[str]) -> None:
    """Render a DOT graph with module rules collapsed into single nodes."""
    with tempfile.TemporaryDirectory() as temporary_directory:
        dot_path = Path(temporary_directory) / "rulegraph.dot"
        dot_path.write_text(left_to_right(dot), encoding="utf-8")
        replace_cross_module_edges(dot_path, prefixes)
        modular_rulegraph_png(dot_path, output, prefixes)


def render(graph_type: str, target: str, output: Path, prefixes: list[str]) -> None:
    """Render the requested graph type to an output file."""
    output.parent.mkdir(parents=True, exist_ok=True)
    dot = rulegraph_dot(target)

    if graph_type == "rulegraph":
        render_rulegraph(dot, output)
    else:
        render_modulegraph(dot, output, prefixes)

    click.echo(f"Created {output}")


@click.group()
def main() -> None:
    """Render Snakemake rule graphs and simplified module graphs."""


@main.command()
@click.option("--target", default="", help="Optional Snakemake output-file target.")
@click.option(
    "--output",
    default="rulegraph.png",
    show_default=True,
    type=click.Path(path_type=Path, dir_okay=False),
    help="PNG file to create.",
)
def rulegraph(target: str, output: Path) -> None:
    """Render a Snakemake rule graph."""
    render("rulegraph", target, output, [])


@main.command()
@click.option("--target", default="", help="Optional Snakemake output-file target.")
@click.option(
    "--output",
    default="modulegraph.png",
    show_default=True,
    type=click.Path(path_type=Path, dir_okay=False),
    help="PNG file to create.",
)
@click.option(
    "--modules",
    default="module_geo_boundaries,module_powerplants",
    show_default=True,
    help="Comma-separated rule-name prefixes to collapse into module nodes.",
)
def modulegraph(target: str, output: Path, modules: str) -> None:
    """Render a rule graph with modules collapsed into single nodes."""
    prefixes = [module.strip() for module in modules.split(",") if module.strip()]
    if not prefixes:
        raise click.BadParameter("provide at least one module", param_hint="--modules")
    render("modulegraph", target, output, prefixes)


if __name__ == "__main__":
    main()
