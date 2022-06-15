# Compositor
We've just seen how you can use `grid` to achieve nice layouts very easily. That's great when you have a bunch of renderables of the same size and you want to crate a simple layout. If you want to get fancy using grid is not trivial:

```@example compositor
using Term: Panel
using Term.Layout

plarge = Panel(; width=60, height=10)
psmall = Panel(; width=20, height=10)
panels = repeat([psmall], 3)

plarge / grid(panels, layout=(1, 3))
```

you can do it, of course, but the more complex you get the harder it is to handle. You could also use the normal stacking syntax of course:
```@example compositor
plarge / hstack(panels...)
```

but again you suffer from the same problem if you want to create something like, say, this:
```@example compositor
using Term.Compositors # hide
layout = :(vstack(  # hide
            A(40, 5), B(40, 5),  # hide
            hstack(C(18, 5), D(18, 5); pad=4); pad=1 # hide
        ) # hide
        * E(5, 20) * vstack( # hide
            F(40, 5), G(40, 5),  # hide
            hstack(H(18, 5), I(18, 5); pad=4); pad=1 # hide
        ) / O(85, 5) # hide
) # hide

Compositor(layout) # hide
```
thaat's a total of 10 place holders in a complex layout... surely it must be a pain right?


Nope, not if you use `Compsitor`.
"What is Compositor?" I hear you ask - well let me tell you. 

The idea is that you create the layout you care about using an `Expression` like this:
```@example compositor

layout = :(A(45, 5) * B(45, 5))
```

There `A` and `B` will be two place holders for renderables that make up the layout.
The `(45, 5)` specify the size of the place holders and `*` is the usual stacking operator. 
Give this expression to the `Compositor` and magic happens
```@example compositor
using Term.Compositors

Compositor(layout)
```

`Compositor` parses the expression, creates the place holders and then creates the layout. You just sit back and relax!.

Now, you have a lot of freedom of what goes into the expression, but you need to respect the rule that renderables are specified by a single chacter name and a size. Other than that, go crazy and use all the syntax for stacking renderables you like!
```@example compositor
layout = :(
        vstack(
            A(40, 5), B(40, 5), hstack(C(18, 5), D(18, 5); pad=4); pad=1
        )
)
Compositor(layout)
```

and remember that you can use interpolation in the expression, so a large expression for a complex layout can be broken down into smaller pieces:
```@example compositor
first_column = :(
    vstack(
            A(40, 5), B(40, 5), hstack(C(18, 5), D(18, 5); pad=4); pad=1
        )
)
second_column = :(
    vstack(
            F(40, 5), G(40, 5), hstack(H(18, 5), I(18, 5); pad=4); pad=1
        )
)

layout = :(
         ($first_column * E(5, 20) * $second_column) / O(85, 5)
)

Compositor(layout)
```

easy peasy.


## Compositor content
Some of you will be thinking: "this is all well and good, but I don't want to just show place holders I've got actual content!". Fair enough, so let's add some.

The easiest thing is to pass content to `Compositor` directly:

```@example compositor

panel = Panel(; width=45, height=5)
layout = :(A(45, 5) * B(45, 5))

Compositor(layout; B=panel)
```

done!

But there's more and it's something that warrants an admonition:

!!! warning
    A `Compositor` is not a `Renderable`!!! When stacking renderables, using `grid` etc you get out an actual `Renderable <: AbstractRenderable` which behaves like any good renderable does. `Compositor` does not do that, it does a whole lot more (and even more in the future) but to do that it needs to be different from a renderable. Among other things this means that it can't be stacked/nested with other renderables. But it's worth it!


### Updating a compositor
That's right, you can update a compositor at any time. That's different from, say, using `grid` where you don't have access to its constituents. Here you can grab any element of the layout and update it at will:

```@example compositor
layout = :(A(45, 5) * B(45, 5))

composition = Compositor(layout; B=panel)
update!(composition, :B, panel)
composition
```

nice, but that's not it. You can keep updating stuff!
```@example compositor

another_panel = Panel(; width=45, height=5, background="on_red", style="bold red",  box=:SQUARE)
update!(composition, :B, another_panel)
composition
```

and so on... just make sure that the new content has the correct size specified in `layout` or `Compositor` will complain:
```@example compositor

p = Panel()
update!(composition, :B, p)
composition
```
