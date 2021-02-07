# Study Hub

An Android Application for managing and organizing school life including classes, tasks, assessments and materials.

## Motivation

During the ongoing COVID-19 pandemic, students like myself were having trouble managing their online school life due to the new ways of teaching and learning. To help these people, I built Study Hub. Study Hub is an app that I think will be able to help a lot of people if it is expanded to other platforms like iOS, Web, and Desktop. This is why I built the app using Flutter, a new app development framework made by folks over at Google that allows users to buil cross-platform native applications.

## Features

The app implements many simple features that are intuitive and easy to use so students don't have a tough time navigating the app. Current features include:
- Schedule view where students can add classes. They can also add timings, days of the week the class occurs, and conference links (optional) for their classes.
- Tasks view where students can add and view tasks, and due dates and times for those tasks.
- Assessments view where students can add assessments, dates and times of those assessments and the type of assessment. Students can also see their past scores using a graph view implemented using [charts_flutter](https://pub.dev/packages/charts_flutter).
- Materials view where students can either add files directly from their phones or add links for any online drive.
- Dashboard view where students can see a snapshot of all their tasks, assessments and materials as well as add any of them.
- Class view where students can view the dashboard for one particular class.
- Year selector on every page so user can switch between multiple years and plan ahead or see their past year's views.

## Technology and tools

To build this app, the following major tools and technologies (among others) were used:
- [Dart](https://dart.dev/)
- [Flutter](https://flutter.dev/)
- [Firebase](https://firebase.google.com/)
  - Cloud Firestore
  - Firebase Auth
  - Firebase Storage
- Many Flutter Plugins
