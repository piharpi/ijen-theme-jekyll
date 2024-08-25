---
title: Python Notes from Intro to Machine Learning
date: 2018-04-14 10:00:00 +07:00
tags: [python, machine-learning]
description: Notes and code snippets of Python that I've been collecting so far throughout the "Intro to Machine Learning" course.
---

**This article is for Demo purpose**

The article was originally on [this repo](https://github.com/risan/risanb.com/blob/master/content/posts/python-notes-from-intro-to-machine-learning/index.md)

I rarely use Python. I only have one repository at Github that is written in Python: [iris-flower-classifier](https://github.com/risan/iris-flower-classifier). And it was written two years ago!

A few days ago I took this free course from Udacity: [Intro to Machine Learning](https://eu.udacity.com/course/intro-to-machine-learning--ud120). The machine learning related codes are quite easy to grasp since it simply uses the [scikit-learn](http://scikit-learn.org/) modules. But most of the supporting Python modules that are provided by this course were like a black-box to me. I had no idea how to download a file in Python or what's the difference between a list, a tuple and a dictionary.

That's why I decided to read all of the provided Python modules and implement it myself. I ended up refactor most of the code so it's easier to understand: [github.com/risan/intro-to-machine-learning](https://github.com/risan/intro-to-machine-learning).

So here are some notes and snippets of Python that I've been collecting so far (I'm not even halfway through the course 😝). Also, note that the codes here are still using Python version 2.7.

### Example Table overflow-table

<div class="overflow-table" markdown="block">

| Markdown                | HTML                               |    Rendered Output    |
| :---------------------- | :--------------------------------- | :-------------------: |
| `[Example Link](#link)` | `<a href="#link">Example Link</a>` | [Example Link](#Link) |
| `_Be Italic_`           | `<em>Be Italic<em/>`               |      _Be Italic_      |
| `**Be Bold**`           | `<strong>Be Italic<strong/>`       |      **Be Bold**      |

</div>

\*) _resize to see difference_

### Example Table without-overflow

| Markdown                | HTML                               |    Rendered Output    |
| :---------------------- | :--------------------------------- | :-------------------: |
| `[Example Link](#link)` | `<a href="#link">Example Link</a>` | [Example Link](#Link) |
| `_Be Italic_`           | `<em>Be Italic<em/>`               |      _Be Italic_      |
| `**Be Bold**`           | `<strong>Be Italic<strong/>`       |      **Be Bold**      |

\*) _resize to see difference_

### Main Entry File

Suppose our Python project is stored in `/foo/bar` directory. And this application has one file that serves as the single entry point. We can name this file `__main__.py` so we can run this project simply be referencing its directory path:

```bash
# Referencing its directory.
$ python /foo/bar

# It's equivalent to this.
$ python /foo/bar/__main__.py
```

### Import Python Module Dynamically

Suppose we would like to import a Python module dynamically based on a variable value. We can achieve this through the [`__import__`](https://docs.python.org/2/library/functions.html#__import__) function:

```py
module_name = "numpy"

__import__(module_name)
```

### Multiple Returns in Python

In Python, it's possible for a function or a method to return multiple values. We can do this simply by separating each return value by a comma:

```py
def test():
    return 100, "foo"

someNumber, someString = test()
```

### Importing Modules Outside of the Directory

In order to import a module from outside of the directory, we need to add that module's directory path into the current file with `sys.path.append`. Suppose we have the following directory structure:

```
|--foo
| |-- bar.py
|
|-- tools
| |-- speak_yoda.py
```

If we want to use the `speak_yoda.py` module within the `bar.py`, we can do the following:

```py
# /foo/bar.py
import os

# Use relative path to tools directory.
sys.path.append("../tools")

import speak_yoda
```

However, this won't work if we run the `baz.py` file from outside of its `foo` directory:

```bash
# It works inside of the /foo directory.
$ cd /foo
$ python bar.py

# But it won't work if the code runs from outside of /foo directory.
$ python foo/bar.py
```

To solve this problem we can refer to the `tools` directory using its absolute path.

```py
# /foo/bar.py
import os
import sys

# Get the directory name for this file.
current_dirname = os.path.dirname(os.path.realpath(__file__))

# Use the absolute path to the tools directory
tools_path = os.path.abspath(os.path.join(dirname, "../tools"))
sys.path.append(tools_path)

import speak_yoda
```

## Output

### Print The Emojis

It turns out you can't just print an emoji or any other Unicode characters to the console. You need to specify the encoding type beforehand:

```py
# coding: utf8

print("😅")
```

### Pretty Print

We can use the `pprint` module to pretty-print Python data structure with a configurable indentation:

```py
import pprint
pp = pprint.PrettyPrinter(indent=2)

pp.pprint(people)
```

## Working with Pathname

Read more about pathname manipulations in the [`os.path` documentation](https://docs.python.org/2/library/os.path.html).

### Get Filename From URL

Suppose the last segment of the URL contains a filename that we would like to download. We can extract this filename with the following code:

```py
import os
from urlparse import urlparse

url = "https://example.com/foo.txt"

url_components = urlparse(url)

filename = os.path.basename(url_components.path) # foo.txt
```

### Check if File Exists

To check whether the given file path exists or not:

```py
import os

is_exists = os.path.isfile("foo.txt")
```

### Create a Directory if It Does Not Exists

To create a directory only if it does not exist:

```py
import os
import errno

try:
    os.makedirs(directory_path)
except OSError, e:
    if e.errno != errno.EEXIST:
        raise
```

## Working with Files

### Downloading a File

We can use the `urllib` module to download a file in Python. The first argument is the file URL that we would like to download. The second argument is the optional filename that will be used to store the file.

```py
import urllib

urllib.urlretrieve("https://example.com/foo.txt", "foo.txt")
```

### Extracting Tar File

There's a built-in `tarfile` module that we can use to work with Tar file in Python. To extract the `tar.gz` file we can use the following code:

```py
import tarfile

# Open the file.
tfile = tarfile.open("foo.tar.gz")

# Extract the file to the given path.
tfile.extractall(path)
```

We can pass the `mode` argument to the `open` method. By default, the `mode` would be `r`—reading mode with transparent compression. There are also other mode options that we can use:

- `r:gz`: Reading mode with gzip compression.
- `r:`: Reading mode without compression.
- `a`: Appending mode without compression.
- `w`: Writting mode without compression.
- Checkout other available options in [tarfile documentation](https://docs.python.org/2/library/tarfile.html).

## Working with List

### Generate a List of Random Numbers

Use the `for..in` syntax to generate a list of random numbers in a one-liner style.

```py
import random

# Initialize internal state of random generator.
random.seed(42)

# Generate random points.
randomNumbers = [random.random() for i in range(0, 10)]
# [0.6394267984578837, 0.025010755222666936, 0.27502931836911926, ...]
```

### Pair Values from Two Lists

The built-in `zip` function can pair values from two lists. However, this `zip` function will return a list of tuples instead. To get a list of value pairs, we can combine it with `for..in` syntax:

```py
coordinates = [[x, y] for x,y in zip([5,10,15], [0,1,0])]
# [[5, 0], [10, 1], [15, 0]]
```

### Splitting a List

We can easily split a list in Python by specifying the starting index and it's ending index. Note that the ending index is excluded from the result.

We can also specify a negative index. And also note that both of these indices are optional!

```py
a = [0,1,2,3,4,5]

a[0:3]  # 0,1,2
a[1:3]  # 1,2
a[2:]   # 2,3,4,5
a[:3]   # 0,1,2
a[0:-2] # 0,1,2,3
a[-2:]  # 4,5
a[:]    # 0,1,2,3,4,5
```

### Filtering a List In One Line

We can easily filter a list in Python by combining the `for..in` and the `if` syntax together:

```py
numbers = range(1,11)

# Filter even numbers only.
[numbers[i] for i in range(0, len(numbers)) if numbers[i] % 2 == 0]
# [2, 4, 6, 8, 10]
```

### Sorting a List in Ascending Order

In Python, we can sort a list in ascending order simply by calling the `sort` method like so:

```py
people = ["John", "Alice", "Poe"]
people.sort()
print(people) # ["Alice", "John", "Poe"]
```

### Using Filter Function with a List

Just like its name, we can use the `filter` function to filter out our list:

```py
numbers = range(1, 11)

even_numbers = filter(lambda number: number % 2 == 0, numbers)
# [2, 4, 6, 8, 10]
```

We can break the above statement into two parts:

- `lambda number: statement`: The first part is the function that we would like to run to every item on the list. `number` is the variable name we'd like to use in this function to refer to a single item from the `numbers` list. The following function body must evaluate to truthy/falsy value—falsy means the current item will be removed from the final result.
- `numbers`: The second parameter is the list that we'd like to filter.

### Using Reduce with a List of Dictionary

We can use the `reduce` function to calculate the total of a particular key in a list of a dictionary:

```py
items = [{value:10}, {value:20}, {value:50}]

# Calculate the total of value key.
totalValues = reduce(lambda total, item: total + item["value"], items, 0) # 80
```

It can be broken down into 4 parts:

- `lambda total`: It's the variable name that we'd like to use in the function body to refer to the carried or the accumulative value that will finally be returned.
- `item: statement`: `item` is the name of the variable we'd like to use within the function body to refer to the single item in the `items` list. The following function body will be executed in order to define the accumulative value of `total` for the next iteration.
- `items`: It's the list of item that we would like to "reduce".
- `0`: The last parameter is optional and it's the initial accumulative value for the first iteration.

We can also use this `reduce` function to find a single item from the list. Here's an example of code to find the person with the biggest `total_payments` within the given list of `people` dictionary.

```py
people = [
    {"name": "John", "total_payments": 100},
    {"name": "Alice", "total_payments": 1000},
    {"name": "Poe", "total_payments": 800}
]

person_biggest_total_payments = reduce(lambda paid_most, person: person if person["total_payments"] > paid_most["total_payments"] else paid_most, people, { "total_payments": 0 })
# {'name': 'Alice', 'total_payments': 1000}
```

## Working with Dictionary

### Loop Through Dictionary

We can use the `itervalues` method to loop through a dictionary:

```py
for person in people.itervalues():
    print(person["email_address"])
```

We can also use the `iteritems` method if we want to access the key too:

```py
for person in people.iteritems():
    print(person[0] + ": " + person[1]["email_address"])
```

### Calculate Total of Particular Dictionary Key

Suppose we would like to calculate the total amount of `salary` key on a `people` dictionary. We can extract the `salary` key and use the `sum` function to get the total:

```py
total_salary = sum([person["salary"] for person in people.itervalues()])
```

## Working with Numpy

### Numpy Create Range of Values with The Given Interval

Use the [`arange`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.arange.html) method to create an array with an evenly spaced interval.

```py
import numpy as np

np.arange(0, 5, 1)
# array([0,1,2,3,4])

np.arange(1, 4, 0.5)
# array([1. , 1.5, 2. , 2.5, 3. , 3.5])
```

### Numpy Create Coordinate Matrices from Coordinate Vectors

We can use the Numpy [`meshgrid`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.meshgrid.html) method to make coordinate matrices from one-dimentional coordinate arrays.

```py
import numpy as np

np.meshgrid([1, 2, 3], [0, 7])
# [
#   array([[1,2,3], [1,2,3]]),
#   array([[0,0,0], [7,7,7]])
# ]
```

### Flatten Numpy Array

When we have a multi-dimensional Numpy array, we can easily flatten it with the [`ravel`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.ravel.html) method:

```py
import numpy as np

arr = np.array([[1,2], [3,4]])
arr.ravel()
# array([1, 2, 3, 4])
```

### Pairing Array Values with Second Axis

We can use Numpy `c_` function to pair array values with another array that will be it's second axis. Read the [`numpy.c_` documentation](https://docs.scipy.org/doc/numpy/reference/generated/numpy.c_.html).

```py
import numpy as np

x = [1,2]
y = [10,20]

np.c_[x, y]
# array([1,10], [2,20])
```

### Generate Coordinates Across The Grid

With the knowledge of Numpy [`arange`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.arange.html), [`meshgrid`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.meshgrid.html), [`ravel`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.ravel.html) and [`c_`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.c_.html) methods, we can easily generate an evenly spaced coordinates across the grid so we can pass it to the classifier and plot the decision surface.

```py
import numpy as np

# Generate an evenly spaced coordinates.
x_points, y_points = np.meshgrid(np.arange(x_min, x_max, step), np.arange(y_min, y_max, step))

# Pair the x and y points.
test_coordinates = np.c_[x_points.ravel(), y_points.ravel()]
```

## Plotting the Data

### Plot The Surface Decision

We can pass an evenly spaced coordinates across the grid to the classifier to predict the output on each of that coordinate. We can then use [`matplotlib.pyplot`](https://matplotlib.org/api/pyplot_api.html) to plot the surface decision.

```py
import matplotlib.pyplot as plt
import pylab as pl

# Pass coordinates across the grid.
predicted_labels = classifier.predict(test_coordinates)

# Don't forget to reshape the output array dimension.
predicted_labels = predicted_labels.reshape(x_points.shape)

# Set the axes limit.
plt.xlim(x_points.min(), x_points.max())
plt.ylim(y_points.min(), y_points.max())

# Plot the decision boundary with seismic color map.
plt.pcolormesh(x_points, y_points, predicted_labels, cmap = pl.cm.seismic)
```

The classifier output would be a one-dimensional array, so don't forget to [`reshape`](https://docs.scipy.org/doc/numpy/reference/generated/numpy.reshape.html) it back into a two-dimensional array before plotting. The `cmap` is an optional parameter for the color map. Here we use the `seismic` color map from `pylab` module. It has the red-blue colors.

### Scatter Plot

We need to separate the test points based on its predicted label (the speed). So we can plot the test points with two different colors.

```py
# Separate fast (label = 0) & slow (label = 1) test points.
grade_fast = [features_test[i][0] for i in range(0, len(features_test)) if labels_test[i] == 0]
bumpy_fast = [features_test[i][1] for i in range(0, len(features_test)) if labels_test[i] == 0]
grade_slow = [features_test[i][0] for i in range(0, len(features_test)) if labels_test[i] == 1]
bumpy_slow = [features_test[i][1] for i in range(0, len(features_test)) if labels_test[i] == 1]

# Plot the test points based on its speed.
plt.scatter(grade_fast, bumpy_fast, color = "b", label = "fast")
plt.scatter(grade_slow, bumpy_slow, color = "r", label = "slow")

# Show the plot legend.
plt.legend()

# Add the axis labels.
plt.xlabel("grade")
plt.ylabel("bumpiness")

# Show the plot.
plt.show()
```

If we want to save the plot into an image, we can use the `savefig` method instead:

```py
plt.savefig('scatter_plot.png')
```

## Dealing with Data

### Deserializing Python Object

We can use [`pickle`](https://docs.python.org/2/library/pickle.html) module for serializing and deserializing Python object. There's also the `cPickle`—the faster C implementation. We use both of these modules to deserialize the email text and author list.

```py
import pickle
import cPickle

# Unpickling or deserializing the texts.
texts_file_handler = open(texts_file, "r")
texts = cPickle.load(texts_file_handler)
texts_file_handler.close()

# Unpickling or deserializing the authors.
authors_file_handler = open(authors_file, "r")
authors = pickle.load(authors_file_handler)
authors_file_handler.close()
```

### Split Data for Training and Testing

We can use the built-in [`train_test_split`](http://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html) function from scikit-learn to split the data both for training and testing.

```py
from sklearn.model_selection import train_test_split

features_train, features_test, labels_train, labels_test = train_test_split(texts, authors, test_size = 0.1, random_state = 42)
```

The `test_size` argument is the proportion of data to split into the test, in our case we split 10% for testing.

### Vectorized the Strings

When working with a text document, we need to vectorize the strings into a list of numbers so it's easier and more efficient to process. We can use the [`TfidfVectorizer`](http://scikit-learn.org/stable/modules/generated/sklearn.feature_extraction.text.TfidfVectorizer.html) class to vectorize the strings into a matrix of TF-IDF features.

```py
from sklearn.feature_extraction.text import TfidfVectorizer

vectorizer = TfidfVectorizer(sublinear_tf = True, max_df = 0.5, stop_words = "english")
features_train_transformed = vectorizer.fit_transform(features_train)
features_test_transformed = vectorizer.transform(features_test)
```

Word with a frequency higher than the `max_df` will be ignored. Stop words are also ignored—stop words are the most common words in a language (e.g. a, the, has).

### Feature Selection

Text can have a lot of features thus it may slow to compute. We can use scikit [`SelectPercentile`](http://scikit-learn.org/stable/modules/generated/sklearn.feature_selection.SelectPercentile.html) class to select only the important features.

```py
selector = SelectPercentile(f_classif, percentile = 10)
selector.fit(features_train_transformed, labels_train)
selected_features_train_transformed = selector.transform(features_train_transformed).toarray()
selected_features_test_transformed = selector.transform(features_test_transformed).toarray()
```

The `percentile` is the percentage of features that we'd like to select based on its highest score.

**This article is for Demo purpose**

The article was originally on [this repo](https://github.com/risan/risanb.com/blob/master/content/posts/python-notes-from-intro-to-machine-learning/index.md)
