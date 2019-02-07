---
id: 827
title: Bringing interfaces to Python
date: 2018-12-07T12:42:13+00:00
author: Tyler Green
layout: post
guid: http://www.tyleragreen.com/blog/?p=827
permalink: /blog/2018/12/bringing-interfaces-to-python/
categories:
  - Projects
tags:
  - open-source
  - python
---
I am a big fan of polymorphic code. My current mantra is "our code should do one thing, it may just behave differently sometimes." Towards this end, I often write classes that implement a common interface (that is, same methods and same signatures on those methods).

I wasn't thrilled with my options for enforcing this using Python. A few people recommended [ABC](https://docs.python.org/3.7/library/abc.html), Python's abstract base class implementation, which I have used successfully in the past. However, I'm not a fan of its syntax or its overhead. I believed I could write something cleaner, even if it was just a proof-of-concept.

I envisioned the following syntax, and wrote failing tests to guide my implementation.

```
from interface import interface

class Iterable:
    def be_iterable(self):
        pass

@interface(Iterable)
class Foo:
    def __init__(self):
        pass

# raises InterfaceException
```

`interface` is a decorator class which works by creating a wrapper class around the user class (`Foo`). It checks that the user class implements the expected methods at the time of class definition, and raises an `InterfaceException` if it does not. After a class definition is successful, it proxies all attribute and method requests to the user class.

Writing tests was key, as my [inheritance tests](https://github.com/tyleragreen/python-interfaces/blob/master/tests/test_inheritance.py) found a critical bug. I was attempting to test that a user class' inheritance hierarchy is preserved by the wrapper class, but the test showed the opposite. The fix was for the wrapper class to inherit from the user class' parent classes using `*Klass.__bases__`. 

The code lives <a href="https://github.com/tyleragreen/python-interfaces" rel="noopener" target="_blank">on GitHub</a> and can be <a href="https://pypi.org/project/python-interfaces/" rel="noopener" target="_blank">downloaded from PyPi</a>. However, the library is definitely still in beta (v0.1.2 is latest, as of this writing).

Some other things which would be interesting to explore:
  
1. Support for dunder methods
  
2. Method signature enforment
  
3. Requiring interface methods to be empty/abstract/`pass`-only

`interface` was a great learning experience and I&#8217;m hoping to produce more Python libraries in the future! Let me know if you have any related ideas. Or&#8230; open a PR. <img src="http://i2.wp.com/www.tyleragreen.com/blog/wp-includes/images/smilies/simple-smile.png?w=676" alt=":)" class="wp-smiley" style="height: 1em; max-height: 1em;" data-recalc-dims="1" />
