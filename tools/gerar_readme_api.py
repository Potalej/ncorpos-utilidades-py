import inspect
import ncorpos_utilidades as nut

def is_public_function(obj):
  return inspect.isfunction(obj) and not obj.__name__.startswith("_")


def format_function_md(func):
  name = func.__name__
  doc = inspect.getdoc(func) or "*Sem docstring*"

  md = []
  md.append(f"### `{name}`")
  md.append("")
  md.append("```text")
  md.append(doc)
  md.append("```")
  md.append("")

  return "\n".join(md)


def main():
  lines = ["## Funções disponíveis:", ""]

  for name, obj in inspect.getmembers(nut, is_public_function):
    lines.append(format_function_md(obj))

  texto = "\n".join(lines)

  # agora adiciona no readme principal
  with open("tools/readme_base.md", "r") as arq:
    texto_base = arq.read()

  with open("README.md", "w") as arq:
    arq.write(texto_base + "\n\n" + texto)

if __name__ == "__main__":
  main()