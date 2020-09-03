from setuptools import setup, find_packages

setup(
    name="namegenerator",
    version="0.1",
    packages=find_packages(),
    entry_points={"console_scripts": ["namegenerator = namegenerator.main:main"]},
    author="Matthias Hölzl",
    author_email="tc@xantira.com",
    description="A generator for random names",
    long_description="""# Long description
    
    """,
    long_description_content_type="text/markdown",
    url="https://gitlab.com/mhoelzl/python-programmierer",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: ISC License (ISCL)",
        "Operating System :: OS Independent",
        "Development Status :: 3 - Alpha",
    ],
    python_requires=">=3.7",
)
