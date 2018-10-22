- You are building an online learning platform. You’ve got many different courses, each with a `title` and `description`, and each course has multiple `lessons`. Lesson content consists of a `title` and `body` text.

```ruby

Courses
-------
id: integer
title: string [present]
description: string [present]
created_at: datetime
updated_at: datetime

has_many lessons

Lessons
-------
id: integer
title: string [present]
text: string [present]
body: string [present]
created_at: datetime
updated_at: datetime
```


- You are building the profile tab for a new user on your site. You are already storing your user’s `username` and `email`, but now you want to collect demographic information like `city`, `state`, `country`, `age` and `gender`.

```ruby

Users
-----
username: string [present, unique]
email: string [present]
city: string [present]
state: string [present]
age: integer [present]
gender: integer [present]
created_at: datetime
updated_at: datetime

Profile
-------
id: integer
user_id: integer
created_at: datetime
updated_at: datetime
belongs_to User

User has one profile
```

- You want to build a virtual pinboard, so you’ll have users on your platform who can create “pins”. Each pin will contain the URL to an image on the web. Users can comment on pins (but can’t comment on comments)

```ruby
Users
-----
id: integer
created_at: datetime
updated_at: datetime

has_many :pins
has_one :comment

Pins
----
id: integer
created_at: datetime
updated_at: datetime
image_url: string [present]

belongs_to :user
has_many :comments 

Comments
--------
id: integer
created_at: datetime
updated_at: datetime
user_id: integer
pind_id: integer

belongs_to :pin

```
