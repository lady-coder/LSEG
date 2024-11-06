import argparse


class Validate:
    def validate_args(self):

        parser = argparse.ArgumentParser()
        parser.add_argument('--bucket', '-b', help="MWAA env bucket name", type=str, required=True)
        parser.add_argument('--directory', '-d', help= "Directory relative path to upload", type=str,required=True)

        try:
            args = parser.parse_args()
            return args

        except Exception as e:
            print(str(e))
            print(parser.format_help())
            exit(2)
