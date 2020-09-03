from setuptools import setup

setup(
    name="numbergame",
    version="0.1",
    packages=["numbergame"],
    entry_points={"console_scripts": ["numbergame = numbergame.main:main"]},
    author="Matthias Hölzl",
    author_email="tc@xantira.com",
    description="Example project for packaging",
    long_description="""# Example project: guess a number
    
    This project is an example for packaging a project""",
    long_description_content_type="text/markdown",
    url="https://gitlab.com/mhoelzl/python-ml-basics",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: ISC License (ISCL)",
        "Operating System :: OS Independent",
        "Development Status :: 3 - Alpha",
    ],
    python_requires=">=3.8",
)
