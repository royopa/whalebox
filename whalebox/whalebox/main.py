import click
import yaml

class Whalebox(object):
    def __init__(self, conf=None):
        self.whaleboxes = self.create_whaleboxes(yaml.load(open(conf)))        

    def base_docker_command(self):
        return 'docker run -ti --rm $(get_root_volumes) -v $(get_home):/root/ -v $(get_pwd):/wd/ -w /wd/'

    def create_whalebox(self, element):
        cmd, cfg = element.popitem()
        docker_command = self.base_docker_command() + ' ' + cfg.get('image')
        if 'cmd' in cfg:
            docker_command = docker_command + ' ' + cfg.get('cmd')
        return {
            "alias" : cmd,
            "command" : docker_command
        }

    def create_whaleboxes(self, elements):
        return [self.create_whalebox(element) for element in elements]

    def sh_alias(self, whalebox):
        return "alias " + whalebox["alias"] + "='" + whalebox["command"] + "'"

    def sh(self):
        return [self.sh_alias(whalebox) for whalebox in self.whaleboxes]

@click.group()
@click.option('--whaleboxes-file', envvar='WHALEBOXES')
@click.pass_context
def cli(ctx, whaleboxes_file):
    ctx.obj = Whalebox(conf=whaleboxes_file)

@cli.command()
@click.pass_context
def sh(ctx):
    sh_aliases = ctx.obj.sh()
    for alias in sh_aliases:
        click.echo(alias) 

if __name__ == '__main__':
    cli()