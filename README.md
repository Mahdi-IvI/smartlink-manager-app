# smart_link_manager

The SmartLink Management App is designed specifically for hotel and student accommodation administrators to manage guest access, room statuses, and communication with guests. This app is optimized for tablet use and provides administrators with a robust set of tools to streamline property management and enhance guest experience.

## Features

1. Login Page

The login page allows administrators to log in using their username, password, and phone number. The authentication process includes a two-factor authentication (2FA), where a verification code is sent to the registered phone number after entering the username and password.

2. Home Page

The home page provides an overview of the main features and statistics. It includes buttons for navigating to different sections of the app:

	•	All Rooms: View an overview of all rooms.
	•	Available Rooms: View a list of all available rooms.
	•	Occupied Rooms: View a list of all occupied rooms.
	•	Tickets: Access the ticket management system.
	•	Group Chat: Access the group chat room.
	•	News: View and manage news and updates.

3. Rooms Page

The rooms page displays a list of all rooms with their current status (available or occupied). Administrators can click on a room to view detailed information such as its location, current status, current guest, and a history of access events.

4. Guests Page

The guests page allows administrators to manage guest access. Administrators can view, add, and manage guests. Adding a guest involves entering a personal code, passport number, first name, last name, phone number, and access dates. The app automatically fills in known details and provides available rooms for the given date range.

5. Info Page

The info page displays detailed information about the property, including name, email, website, phone number, and description. Administrators can edit this information by clicking on the edit button, which takes them to a page where they can update property details and upload images.

6. Ticket Page

The ticket page is used for managing guest tickets. Administrators can view, respond to, and resolve tickets submitted by guests. This feature is only visible if the ticket system is enabled for the property.

7. Chatroom Page

The chatroom page allows administrators to engage in group chats with guests. This feature is typically used in student accommodations. The chat history is displayed along with an input field for sending new messages.

8. News Page

The news page displays all news and updates related to the property. Administrators can view previous news and add new news items by clicking on the + button. They can enter a subject, description, and upload images to accompany the news.

Installation

To install the SmartLink Management App, follow these steps:

	1.	Download the app from the Google Play Store or Apple App Store.
	2.	Open the app on your tablet and follow the on-screen instructions to set it up.
	3.	Log in using your administrator credentials to start using the app.

Technical Details

The app is built using Flutter and leverages Firebase for authentication, real-time database, Firestore, and storage. It supports comprehensive management functionalities tailored for large-screen tablet use.

Contributing

We welcome contributions from the community. If you’d like to contribute, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.

License

The SmartLink Management App is licensed under the MIT License. See the LICENSE file for more information.

Contact

For any questions or support, please contact us at support@smartlink.com.
