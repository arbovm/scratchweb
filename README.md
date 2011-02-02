# Why not to rewrite the web from scratch?

### This is a Challenge:

Design and implement a system that will accept a multipart form upload
(say, containing an audio file) while displaying a percentage
progress.

The basic HTML design should look like:

- Display form with file input field
- Display a title text field
- Display a status text paragraph "select file"
- Optionally display a submit button

### Specification:

- When the user picks a file from their computer and the form is submitted, the upload begins.
- While uploading, the status text paragraph should be updating with the
current percentage complete at least once every 2 seconds.
- While uploading, the user should be able to enter text into the title
text field.

- When the upload completes, the status text should display the path on the server to the saved file, 
and the current value of the title text field should be posted to the server. 
- The response to the form post request should display both the title and the path to the file.

### Requirements:

- The upload should honor proxy settings on the browser
- The system must function behind a firewall that blocks all but port 80
- The server must support at least 2 concurrent uploads from different users
- Any technology that can be web deployed to IE, Firefox, Safari, Chrome
(iPad/iPhone is optional) on __any platform__ is supported
- Use any language you'd like but with __fewest dependencies as possible__

## My Approach:

To show my skills and my understanding on protocol level up to the MVC pattern, I decided
to take the requirement __"fewest dependencies as possible"__ very serious. I did something 
I would never do in my daily work: I only depend on Ruby an its own libraries (socket and tempfile) in the Back-end and wrote
everything from scratch. Usually I don't like to reinvent things, but I want to proof that i can do this.

### Decisions:

- Ruby 1.9.2
- MVC Application: A model layer, views and a set of actions. Completely separate from the web framework.
- Sinatra-like DSL with named path params like "/uploads/:id/file/:title"
- As RESTful as possible
- A pseudo database which is just a nested Hash. But it is completely separate from the web framework and web application.
- JQuery for Front-end code
- High-Level Front-end code with Ajax and JSON. No web server specific hacks.
- No dynamic views, just JavaScript
- A deadline of __one week__

### Tested on:
- Mac OS X
  - Chrome 8
  - Safari 5
  - Firefox 3 __(I had to completely disable Firebug in Add-ons menu)__
  - Firefox 4beta10

- WinXP
  - Firefox 2
  - IE6
  - IE8


