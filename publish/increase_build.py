import argparse
import re

arg_parser = argparse.ArgumentParser(add_help=False)
arg_parser.add_argument('pubspec',
                        default='pubspec.yaml',
                        help='Path to the build.gradle')
arg_parser.add_argument('new_version',
                        help='Name of the new version')


def increase_build_number(path_to_pubspec, version_name):
    with open(path_to_pubspec, 'rt') as f:
        pubspec = f.read()

    r = re.compile(r'version: (\d+).(\d+).(\d+)\+(\d+)')
    m = r.findall(pubspec)
    code = int(m[0][3]) + 1
    with open(path_to_pubspec, 'wt') as f:
        f.write(r.sub('version: %s' %
                      f'{version_name}+{code}', pubspec))


flags = arg_parser.parse_args()
pubspec = flags.pubspec
new_version = flags.new_version
increase_build_number(pubspec, new_version)