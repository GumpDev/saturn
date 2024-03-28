<p align="center">
  <img src="icon.png" height="200px" />
</p>

# Saturn

A Godot Plugin to manage simple cascade state machine

> Works only on Godot 4.x versions

<br>

## Table of Contents

- [🪐 What is Saturn?](#what-is-saturn)
- [🔧 Installation](#installation)
- [📝 Getting Started](#getting-started)
- [🤔 FAQ](#faq)

<br>
<a id="what-is-saturn"></a>

## 🪐 What is Saturn?

The main goal is to create simple state machine manager, with a friendly UI and simple configuration

### Simple Cascade State Machine

![](images/image1.png)

Create your state machine and saturn will return the first state that can reach

<br>
<a id="installation"></a>

## 🔧 Installation

- You can search "Saturn" on Godot Assets Library
- You can download this repo, copy and paste the `addons/saturn` into your project's folder

<br>
<a id="getting-started"></a>

## 📝 Getting Started

### Creating a Componentable

To start just select a node and in the inspector click on `Create Componentable`

![Inspector with a Create Componentable Button](images/create_componentable.png)

Then will be create a Component Script for your node, and your node will be ready to have components

In this example, the Component Script created will be `PlayerComponent`, because de class_name of the script in this node is Progress.

> Node don't need to have a script, componentable can be used with build-in types

<br>

### Creating a Component

Just create a Script with a `class_name` and extends `PlayerComponent`, then you can place the behaviour you want inside this component.

in the `PlayerComponent` we have:

```godot
class_name PlayerComponent extends Node

@export var active = true
@export var player: Player
```

so we can access the player using the `player` variable.

<br>

So for in our component example `Glowing` will make the player glow with:

```godot
class_name Glowing extends PlayerComponent

func _ready():
	if active: # active is a variable inside PlayerComponent to make some enabling behaviours
		create_tween().tween_property(player, "modulate:a", 0, 1)
```

then you select the `Componentable` node you can select the component

<br>

![](images/enabling_component.png)

> This list of components will show all components that is from this node type and node parent types

when selected a component will show up as a node in components node of your `Componentable`

<br>

![Alt text](images/component_node.png)

Here you can see that we have two variables `player` that will be automatic assign as the `Componentable` Node, and the `active` variable, that will disable the behavior in your logic.

You can make more exported variables to create more customization to your component

<br>

### Getting a Component from a Node

When you want to get a component from a `Componentable`, you can use:

```godot
var glowing: Glowing = Component.find(self, "Glowing")
```

If you want to get a component from a other node, you can use:

```godot
var glowing: Glowing = Component.find(player, "Glowing")
```

> Just remember the component can be null

<br>

### Adding or removing component in runtime

To add a component to a componentable in runtime you can use:

```godot
Component.subscribe(node, "ComponentName")
```

and to remove a component you can use:

```godot
Component.unsubscribe(node, "ComponentName")
```

<br>

### Some others functions

```godot
Component.componentable(node) # will create a Component Script if don't exists to this node, and define this node as a componentable

Component.uncomponentable(node) # will make this node not a Componentable any more

Component.is_componentable(node) # return true if this node is a componentable

Component.has(node, "component") # return true if this componentable have this component

Component.get_all(node) # return all components in this componentable
```

<br>
<a id="faq"></a>

## 🤔 FAQ

- **Why you created that?** _Cuz is so boring to create an Item with a custom name in Bukkit, it's more than 4 lines, and I'm lazy_
- **I Found a BUG!** _[Click here](https://github.com/GumpDev/componentable/issues) and open an issue_
- **Can I help with the project?** _Sure! just send your PR :D_
- **Can I contact you?** _Yep, send email to contact@gump.dev_
