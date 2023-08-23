import os, shlex, argparse, pathlib


def docker_cmd(*args):
    qcmd = shlex.quote(" && ".join(["cd /home/rstudio/workspace/"] + list(args)))
    return f"docker run --rm -v $PWD:/home/rstudio/workspace -e USERID=$UID meenaljhajharia/bda-docker:latest su -c {qcmd} rstudio"


def docker_run(*args): 
    user = os.environ.get("USER")
    print(f"[{user}]: Running:\n", "\n".join(args))
    if user not in [None, "rstudio"]:
        print("I think we ARE NOT on docker...")
        os.system(docker_cmd(*args))
    else:
        print("I think we ARE on docker...")
        os.system(" && ".join(args))


parser = argparse.ArgumentParser(
                    prog='docker_quarto_render',
                    description='Renders quarto files using docker')
parser.add_argument('paths', nargs='+')
args = parser.parse_args()

for path in args.paths:
    rel_path = pathlib.Path(path).relative_to(".")
    docker_run(f"quarto render {shlex.quote(str(rel_path))}")
