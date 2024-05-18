GlobUs:

GlobUs is a social networking app tailored for travelers who wish to connect with nearby fellow travelers spontaneously, and create mutual experiences.
Whether you’re on a business trip with some spare time for hiking or a solo traveler seeking to spice up your journey by sharing an adventure with a new mate, GlobUs is designed to facilitate those needs.

Must-have functionalities:

Chat — Given the social nature of our app, incorporating a means of communication between users was necessary. Therefore, we had to establish chat service.

Profile — To facilitate the seek for ideal travel companions, we enabled users to create informative profiles that showcase their personalities effectively. Each profile includes essential details such as a profile image, bio, location, and age. Additionally, during the registration process, users have the option to choose custom tags that reflect their preferences and interests related to travel.

Matching board — we’re far away from being pioneers with the matching concept, but I will elaborate a little bit more on a related mechanism we implemented in this feature later on. 

Later on, we delved into finer details, putting ourselves in the user’s position and pondering what concerns or needs could arise while using GlobUs. Here are some of the primary ideas that emerged from our brainstorming:

Trust your mate — Building trust with a stranger, particularly in a foreign setting, can be intimidating for some. To address this, we introduced the ‘profile endorsement’ concept. Users have the ability to endorse each other after meeting and sharing mutual experiences. These endorsements are then displayed on the user’s matching card, providing insights that can help other users trust their potential partners.

Control your preference — Each user may have specific preferences when selecting a partner, considering various factors. Accordingly, we enabled customizing the order of cards based on multiple criteria such as age, location, shared tags, and more. For instance, if a user decides to prioritize tags, their initial potential matches will be those with the most correlated tags.

Live updates —While the matching system itself is not groundbreaking in social apps, we prioritized designing this functionality to be as dynamic and flexible as possible. Considering the nature of travel, where users are often on the move or experiencing changes, it was crucial for us to adhere to this principle. To achieve this, we devised a grading algorithm that detects users’ changes and sorts potential matching cards accordingly. This mechanism ensures that after a user swipes a card right or left, the subsequent card shown is the most relevant for them.
