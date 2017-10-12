from setuptools import setup, find_packages

setup(
    name='whalebox',
    version='0.1',
    packages=find_packages(),
    include_package_data=True,
    install_requires=[
        'Click',
        'pyyaml',
    ],
    entry_points='''
        [console_scripts]
        whalebox=whalebox.main:cli
    ''',
)