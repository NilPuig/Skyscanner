# Skyscanner App Recruitment test

Thanks for taking the time to do our app coding test. 

Please complete the challenge within 7 days.

You will find the files referenced in the instructions below in the supplied ZIP file (if it has not downloaded automatically, there is a download link is at the top of this screen).

The challenge has two parts:

1) a task to create a basic flight search UI and necessary network component that speaks to our 'live pricing' API

2) some follow-up questions - see the file `./FOLLOW-UP.md`

----

Feel free to spend as much or as little time as you'd like, as long as the following have been met:

* Your implementation works as described in the Task section below, retrieving results from our API (details below).

* Your solution looks like the provided in the `/designs/results-phone.png` file.

* You are encouraged to add code and files to your submission. Edits to the README.md or design files (made available as images) will be ignored.

----

## Task

- Use our 'live pricing' API to find **return flights from Edinburgh to London, departing next Monday and returning the following day**.

- In order to successfully call the API you can find the details in the api section below

- Use the returned data to display a page of results that matches the design provided.

## Design

![Alt](https://github.com/NilPuig/Skyscanner-Test/blob/master/results.png)

We've provided a design for phone layout (see `/designs/results-phone.png`). Don't worry about tackling tablet screens.

Don't worry about implementing menu functionality or sorting/filtering/alerting - these controls can be display-only.

You can see the designs both as png and as sketch, which you can use to see the more specific details. (You can download sketch from [here](https://www.sketchapp.com/))

For the airline logos, try the favicon size per code: e.g. https://logos.skyscnr.com/images/airlines/favicon/EZ.png

## Client implementation

Feel free to choose what technology or 3rd party libraries you use during the implementation.

The iOS project that you create should be put into the app folder.

## API implementation

You will need to call a real Skyscanner API for this task.

Please use the API key: *** to call the API.

The underlying Skyscanner [API documentation is available here](https://github.com/Skyscanner/api-documentation/tree/master/live_flights_pricing) and a [test harness is provided](http://business.skyscanner.net/portal/en-GB/Documentation/FlightsLivePricingQuickStart) for you to try queries out.

You can use the Skyscanner `sky` location schema, and the `EDI-sky` and `LOND-sky` placenames in your query.

The API will return collections of different items:

* **Itineraries** - These are the container for your trips, tying together **Legs**, and **prices**. Prices are offered by an **agent** - an airline or travel agent.

* **Legs** - These are journeys (outbound, return) with **duration**, and **carriers**<sup>[1](#footnote1)</sup>. These contain one or more **Segments** and **stops**.

* **Segments** - Individual flight information with directionality.

A good structure to represent trip options would be hierarchical:

```
Itineraries
  Legs
    Segments
```

Your key will be rate-limited to ~5 queries per minute.

## Submission Guidelines

* Please re-zip the top level folder: `app-recruitment-test-master` to create a `app-recruitment-test-master.zip` file.

* Where possible retain the folder structure provided. You can of course create additional folders and files but ideally you should not reorganise the supplied files.

* The zip file should contain the [FOLLOW-UP.md](./FOLLOW-UP.md) file with answers to the follow-up questions.

* Please exclude generated files from your submission. When we review your code it will be built in Xcode.

# Follow-up

## Implementation:

### Q) What libraries did you add to the app? What are they used for?
- Alamofire: for http networking
- Siesta: to use the api more easily.

---


## General:

### Q) How long did you spend on the test?

Around 5 days, devoting 2-3 hours each day.

### Q) If you had more time, what further improvements or new features would you add?

I would try to make the scrolling more smooth.

### Q) Which parts are you most proud of? And why?

The overall final design.

### Q) Which parts did you spend the most time with? What did you find most difficult?

Fetching certain information using API

### Q) How did you find the test overall? If you have any suggestions on how we can improve the test or our API, we'd love to hear them.

I think it was much more interesting than the usual iOS tests, I like the idea of building something instead of just testing my knowledge.


----

Inspiration for the test format taken with ❤️ from [JustEat's recruitment test](https://github.com/justeat/JustEat.RecruitmentTest).
