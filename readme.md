# General Considerations

## Description

The project was sent to me as a small test for a company called AirTasker based
over in Sydney earlier this year.  They as a company deal in allowing "workers"
to bid on tasks listed by "users".

The task was to implement the UI for this, the UI design is not included and
unimportant for this discussion.

There are three endpoints available which (other than the initial one) must be
built up from the returned data set.

Examples of these data sets are available in the tests directory under the
`TestAssets` directory. 

The initial endpoint fetches the applications basic setup in that it lists a
set of locations that will then be further populated with interlinked data and
as can be seen in the `DataManager` class we can build up the URL scheme of the
application as we go along.

I won't belabour the point, this behaviour is specified in the tests.

I was not interested in pursuing the job opportunity but decided to use the
test as an opportunity to experiment more with testing and architectural
approaches to the problem and also to start working towards building up a
persistence and data networking library instead of just using one off the shelf
as well as to use Swift4's nice new `Serialisable` protocol with regards to the
apps JSON payloads.

I'm not very good at doing nothing and I was in Thailand avoiding winter.

I found it very useful to constrain myself to working within the paradigm of
the initial app design and data. 

I particularly wanted to write the code in a manner whereby I could drive out
an approach of testing core functionality such as the underlying CoreData stack
and URLSession code by using `Protocol Oriented Design` and `Protocol
Extentions` something which I have not had the opportunity to really prod and
poke at.

I concentrated mainly on the parsing and persisting data and wrote the code in
the project in around 2 weeks spaced out over around 6 weeks.

The approach to CoreData is heavily based on the excellent “Core Data" by
Florian Kugler and Daniel Eggert

As such the project is spotty in its architectural approach. It is to my mind a
success in its stated aims of persistence parsing and testing.

## General Approach

It could be implemented in a relatively straight forward manner with a call to
a endpoint and then a data parse to populate the UI. This approach however
would create later issues as there is no way to trivially build up the
`message` portion of the data set as seen in `activities.json` file which
itself is returned as a JSON array in a larger return from a later data call as
can be seen in the `localle5.json` file. This set of data which represents a
location bound set of `activities` is in itself an issue. I will come back to
this a bit later. 

The problems seems to be essentially one of storage between calls and between
views that will show the data and as such it seemed to make sense to use
CoreData to store and model the data rather than build up a set of local
classes. It also allowed for me to try and write a tested implementation of a
locally stored data model.

Ideally I would argue that an application should have a UNI directional data
flow and the best way that I currently know of to implement this in iOS is
using the REDUX pattern which creates an application wide store of state where
each action the application might undertake is despatched to the store as an
action with some state. The store is then responsible for reducing this action,
when this has happened then the stores state is updated. All parties interested
in that state can then be informed of this state change, this in turn can be
neatly implemented  using an Observer pattern. Generally to implement this I
would just use SwiftRX or a similar library. 

That's not what I have have done here, or rather I did this in a similar manner
by using CoreData as an analogue for the store and then fetched results
controllers as the Observer library. 

In this rather simple application this means that on a page load from the
initial screen the necessary data can be fetched from the API, parsed  into the
underlying data model and the consuming view can be updated via the fetched
results controller.

Ideally of course this would all be hidden from the views. In a sense this is
in that each ViewController has an injected data manager that is passed between
them as required and that has methods to fetch the correct data for each view.

This means that the data manager could potentially become unwieldy and really
this should all be handled in reducers using the REDUX store, i.e. a view would
dispatch an action that asks for data, then the reducer for the action uses a
data manager etc...

However the data flow is UNI directional. View->DataManager->View again as
mentioned before this was more an exercise in writing a persistence library
than in writing an application.

The data is then displayed in a CollectionView, badly.

## Testing

This was the biggest area of work in many ways, I want to test out core data
and networking reliant objects and managers yet I cannot mock objects in the
same way that one can with Objective-C.

Fortunately there is a solution, if objects/classes etc. are modelled after
protocols then behaviour can be specified in the same manner as an Abstract
class in Java or similar languages. This allows for the Protocol to declare a
contract of behaviour and then an implementing class to fulfil the contract.

This then gives a mechanism to mock classes we are interested in but do not own
by declaring a Protocol that duplicates or essentially wraps the function calls
we are interested in and then adding this protocol as an `extension` to the
real class, the real class already implements the methods we want and we can
then happily mock out our own implementation where required.

See the `SessionProtocols.swift` and `PersistenceManager.swift` files.

## Generics

Very useful Generics and an attempt has been made to use them as fully as
possible, perhaps successfully certainly in the `PersistenceManager`, the
networking library as it is should also be made generic over `Type` where
`Type` is (in this case) `Managed` or similar. In terms of code outside of the
persistence layers though the code base generally is not.

There is a generic enum `Mapped` that has an associated type parameter which
can then be used with a result of type `<A>` or an error type. The idea here
being to create a custom error type for given parser issues and then return
this or the parsed data to the calling library which can then handle the error. 

This does however create trouble down the line when we get to using this
`Mapped` enum in a Protocol which is of course abstract and thus cannot infer
type from the associated type property, which makes sense so we have to do some
work with type erasure see file `JSONMappingProtocol.swift` for details.

## Obvious Issues

- The ViewControllers do not separate out the data sources and delegates into
  separate injected classes responsible for those tasks.
- The data manager does not cache returned images causing slow image loading
  and due to cell reuse the incorrect image being displayed while it reloads,
  far too many network calls.
- The recent `activities` these have no unique identifier so its hard to
  display them as is as they relate to `profile_id` and `task_id` multiply i.e.
  they have a many to many relationship, rather than solve this in the
  application by adding another handling object in the data store or using the
  empty `created_at` field when fetched I would argue that the API is in fact
  in error as in this case the remote DB should be the source of TRUTH.

## Summary

The persistence library is fully under test as is the networking library by use of `Protocol Oriented Design` and `Protocol Extentions`.

The persistence library is a start at a multi threaded library that could be hooked into a network manager layer and persist data across the app as was intended, its not currently multi threaded but this can be added.

The networking code is overly simple but at this point is only there to get the data into the app in a testable manner.

The views are terrible as is the UI but the UI is dumn and only there to hold it together, the project was about mapping json to persistent data in a tested manner where the tests cover libraries that are out of our hands and need to be injected.
