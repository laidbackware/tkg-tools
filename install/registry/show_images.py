import yaml, sys

from glob import glob
from pprint import pprint
from pathlib import Path

bom_path = f"{str(Path.home())}/.tanzu/tkg/bom/tk*-bom*"
boms = glob(bom_path)

if len(boms) == 0:
  print(f"unable to detect any bom files in {bom_path}")
  sys.exit(1)

images_with_tag = set()
images_name = set()

for bom in boms:
  with open(bom, 'r') as stream:
      try:
          bom_content = yaml.safe_load(stream)
      except yaml.YAMLError as exc:
          print(f"Failed to load yaml from file {stream}")
          print(exc)
          sys.exit(1)
      repositiory = bom_content['imageConfig']['imageRepository']
      for component_versions in bom_content['components'].values():
        for version in component_versions:
          if 'images' in version:
            for image in version['images'].values():
              images_with_tag.add(f"{repositiory}/{image['imagePath']}:{image['tag']}")
              images_name.add(f"{repositiory}/{image['imagePath']}")

def printer(printme):
  for item in sorted(printme):
    print(f"{item}")

print("\n#################\nImages with tag\n##################\n")
printer(images_with_tag)

print("\n##################\nImages without tag\n##################\n")
printer(images_name)
