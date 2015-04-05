[![Build Status](https://travis-ci.org/elfenlaid/swirl.svg?branch=master)](https://travis-ci.org/elfenlaid/swirl)


# swirl
Tiny library inspired by reactive approach

You shouldn't use it yet though :(

## What this is all about
Library consists of two interfaces:

`Rill` is some sort of events emitter. You create `Rill` like so:

```obj-c
SWLRill *rill = [[SWLRill alloc] initWithBlock:^id {
    return @"value";
}];
```

`Rill`'s block return value is accessible via `value` property. Block executes in thread safe manner. Block can be nil.
 
With `Rill` you subscribe to object KVO:

```obj-c
KVOObject *object = [KVOObject new];
[rill addDependencyWithObject:object keyPath:@"number"];

// Trigger rill notification
object.number = @0;
```

`Rill` retains observable object. `Rill` could have more than one dependency.

Whenever dependency triggers, `Rill` would emit KVO notification, but actual `value` wouldn't be calculated till actual property access.

`Rill` events can also be triggered manually.

And one more thing, `Rill` block in ideal shouldn't have side effects, just grab, transform and return value.

On the other hand there's `Sink`. Basically `Sink` transforms events to side effects. You create `Sink` like this:

```obj-c
SWLSink *sink = [[SWLSink alloc] initWithBlock:^{
    data = dataRill.value;
    ...
    [collectionView reloadData];
}];
```

`Sink`'s block executes in thread safe manner.

`Sink` can depend only on `Rill` objects: 

```obj-c
[sink addRillDependency:rill];
```

On each dependency notification, `Sink` would execute its block. `Sink` could have more than one dependency.

====

In order to understand how to use `Rill` and `Sink` you may scroll through examples.
