import os
import yaml

ROLES_DIR = "roles"

graph = {}

missing_meta = []


def get_role_name(path):
    """
    Takes the entire role path and removes the leading "roles/" string.

    Ex:
        path = "roles/system/networking"
        returns "system/networking"

    :param path:
    :type path:
    """
    return path.replace(ROLES_DIR + "/", "")


# print("Building Dependency graph...")


for root, dirs, files in os.walk(ROLES_DIR):
    # If the role contains a meta folder then
    # We can find the main.yaml file within
    # Unless meta/main.yaml file is missing
    if "meta" in dirs:
        role_path = root
        role_name = get_role_name(role_path)

        meta_file = os.path.join(role_path, "meta", "main.yaml")

        deps = []
        # print(meta_file)
        if os.path.exists(meta_file):
            with open(meta_file) as f:
                data = yaml.safe_load(f) or {}
                for dep in data.get("dependencies", []):
                    if isinstance(dep, dict):
                        deps.append(dep.get("role"))
                    else:
                        deps.append(dep)
        else:
            print("Can't find file")

        graph[role_name] = deps
    else:
        role_name = get_role_name(root)
        missing_meta.append(role_name)


# Print edges
print("digraph G {")
for role, deps in graph.items():
    for dep in deps:
        print(f'"{role}" -> "{dep}"')
print("}")

# print("Roles missing meta:")
# for role in missing_meta:
#    print(role)
