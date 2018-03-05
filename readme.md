# General Considerations

* Keeping things locally persisted is good, networks are poor so we consider the remote
DB to be the source of all goodness when it comes to truth.

* There is no mechanism in place for syncing user changes here I would tend to use of
an architecture similar to REDUX whereby we have a unidirectional architecture with some
syncing mechanism in place for writing changes in the local DB to the remote one when we have
connectivity. However I would imagine the use case is reasonably simple for the registered user.
I assume they need to add tasks and accept workers for the tasks and to send messages.
Therefore the remote DB is still the source of truth so we can overwrite objects locally or update.

* The local storage just creates new objects and links them appropriately. It does not attempt
to update them. As there is no mechanism for ser to interact with them other than display them

* Views are notified of changes to the data layer via a fetched results controller.

* Its a good idea to keep all the data controllers etc. separate from the view controllers, i.e. to avoid Massive View Controller
as opposed to MVC also achieving a UNI directional data flow is desirable. This has not been done, each VC is the delegate
and datasource for its collection view/views and fetchedresults controller. Its not ideal but for the sake of the test I have just
done it, there isnt too much logic going on anyway so we end up in the easy to read vs seperation of concerns model...

* Dependencies should all be injected so that they can be tested/mocked.

* Protocols oriented development is good. Wrap dependencies for libs in protocols for mocking
(until the day we get good mocks (please swift team...))

* There is a bug (ish) in display of acticities. We map them to users(profiles) in the data model which makes sense to my
understanding of the data model, however as they have no unique id's and as such we need a mechanism to tie them to the localle which is really
a convenneince model to toe all the relationships in place and ease the parsing of the JSON we receive from the remote store.
I would argue that this is perhaps a API bug/feature.

* Immutability is to be encouraged. Structs and composition are preferred over classes and inheritance.

* BDD is clearer to read and maintain than TDD.

* Try to test first i.e. write a failing test and go from there.


This in not fully tested but it is fairly well covered. The UI is not under test but really it should be modelled in such a way that its logic
and data is restable. This is partially in placed in the sense that the data layer and model layer is under test.

Thanks for the time in reading the code and looking at the project, I hope it makes sense.



