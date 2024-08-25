---
title: React Component with Dot Notation
date: 2018-04-07 23:04:00 +07:00
tags: [javascript, react]
description: Learn how to define a React component that is accessible through the dot notation. A common component pattern to show a parent-child relation.
---

**This article is for Demo purpose**

The article was originally on [this repo](https://github.com/risan/risanb.com/blob/master/content/posts/react-component-with-dot-notation/index.md)

This is my answer to someone's question on [StackOverflow](https://stackoverflow.com/questions/49256472/react-how-to-extend-a-component-that-has-child-components-and-keep-them/49258038#answer-49258038). How can we define a React component that is accessible through the dot notation?

Take a look at the following code. We have the `Menu` component and its three children `Menu.Item`:

```jsx
const App = () => (
  <Menu>
    <Menu.Item>Home</Menu.Item>
    <Menu.Item>Blog</Menu.Item>
    <Menu.Item>About</Menu.Item>
  </Menu>
);
```

How can we define a component like `Menu`? Where it has some kind of "sub-component" that is accessible through a dot notation.

Well, it's actually a pretty common pattern. And it's not really a sub-component, it's just another component being attached to another one.

Let's use the above `Menu` component for example. We'll put this component to its own dedicated file: `menu.js`. First, let's define these two components separately on this module file:

```jsx
// menu.js
import React from 'react';

export const MenuItem = ({ children }) => <li>{children}</li>;

export default const Menu = ({ children }) => <ul>{children}</ul>;
```

It's just a simple functional component. The `Menu` is the parent with `ul` tag. And the `MenuItem` will act as its children. Now we can use these two components like so:

```jsx
import React from "react";
import { render } from "react-dom";
import Menu, { MenuItem } from "./menu";

const App = () => (
  <Menu>
    <MenuItem>Home</MenuItem>
    <MenuItem>Blog</MenuItem>
    <MenuItem>About</MenuItem>
  </Menu>
);

render(<App />, document.getElementById("root"));
```

Where's the dot notation? To make our `MenuItem` component accessible through the dot nation, we can simply attach it to the `Menu` component as a static property. To do so, we can no longer use the functional component for `Menu` and switch to the class component instead:

```jsx
// menu.js
import React, { Component } from 'react';

export default const MenuItem = ({ children }) => <li>{children}</li>;

export default class Menu extends Component {
  static Item = MenuItem;

  render() {
    return (
      <ul>{this.props.children}</ul>
    );
  }
}
```

Now we can use the dot notation to declare the `MenuItem` component:

```jsx
import React from "react";
import { render } from "react-dom";
import Menu from "./menu";

const App = () => (
  <Menu>
    <Menu.Item>Home</Menu.Item>
    <Menu.Item>Blog</Menu.Item>
    <Menu.Item>About</Menu.Item>
  </Menu>
);

render(<App />, document.getElementById("root"));
```

You can also put the `MenuItem` component definition directly within the `Menu` class. But this way you can no longer import `MenuItem` individually.

```jsx
import React, { Component } from "react";

export default class Menu extends Component {
  static Item = ({ children }) => <li>{children}</li>;

  render() {
    return <ul>{this.props.children}</ul>;
  }
}
```

**This article is for Demo purpose**

The article was originally on [this repo](https://github.com/risan/risanb.com/blob/master/content/posts/react-component-with-dot-notation/index.md)
