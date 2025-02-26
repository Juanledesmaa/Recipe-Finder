# my-recipes-private

### Summary: Include screen shots or a video of your app highlighting its features

<img src="https://github.com/user-attachments/assets/db0823b9-fac4-416f-b728-2fde91f33f25" alt="Screenshot_1" width="200">
<img src="https://github.com/user-attachments/assets/e0b6cd21-d173-4bab-8bc3-ca799dc3b58a" alt="Screenshot_2" width="200">
<img src="https://github.com/user-attachments/assets/effaea5f-0208-4ef5-b858-b860b978d829" alt="Screenshot_3" width="200">
<img src="https://github.com/user-attachments/assets/e1f272cf-abd4-44dc-a38c-1db15302885d" alt="Screenshot_4" width="200">

| Scenario                | Video |
|-------------------------|-------|
| Slow Network connection showcasing image cache | https://www.youtube.com/shorts/Avpho--l7L0 |
| Debug configuration showcasing edge cases | https://youtube.com/shorts/HnGCuETkUuw|
| Dark Mode & Light Mode | https://youtube.com/shorts/jjJ-hxJupDM |


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

* User Experience: From the start, the look and feel of the app was my main area of focus. I chose to prioritize this because I believe a user's first impression of an application is shaped by how smooth and useful the experience is.

* Easy Search: I enhanced the experience by allowing users to search for a specific recipe. I focused on this feature to add value to the user experience, making it easier and quicker for users to find the recipes they want.

* Caching and Image Storage: I wanted to improve how users interact with recipe images. Nothing is more frustrating than an app freezing due to background processes the user isn't aware of. To address this, we load images only when needed and store them on the device to prevent unnecessary additional requests for previously viewed images.

* Project Structure & Architecture: As a developer accustomed to working with peers, I know how easy it is to overlook clean structure and proper separation of concerns in the rush of development. From the start, I prioritized a SOLID + DRY approach, ensuring each layer is well-separated based on its responsibility.

* Look and Feel: As a user, I appreciate having the option to use an app in dark mode, so I made sure to include that feature for a more customizable experience.

* Improve Developer Experience: I'm used to working on teams that collaborate on shared features. By adding a debug menu that allows switching between different cases in our flow, we can help developers who are onboarding to our feature gain visual cues on how our project works.


### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spent almost three development days on this project (around 6-8 hours each day). I allocated the time as follows:

1. Project Setup and Architecture (20%)
I began by defining the code layers, folder structure, and separation of concerns. The business models and networking layer were also established at this stage. We verified a successful connection to the app’s remote resources and ensured the business layer was properly integrated.

By setting up a solid foundation and having clear project requirements from the start, I was able to streamline this step and avoid unnecessary delays.

2. View Layer Implementation (30%)
I first created a plain UI using mock data, defining and building all reusable views. My primary focus was on user experience, ensuring:

Smooth keyboard interactions
Optimized scrolling
Efficient image caching
Local storage for images
Due to the emphasis on UX, this phase required the largest time investment.

3. ViewModel Layer Implementation (30%)
Since the project requirements were well-documented, I encountered no major challenges in this layer. We handled all possible ViewModel states, ensuring the UI correctly bound and updated based on data changes.

This step also involved connecting the remote models to the ViewModel and verifying they were properly rendered in the UI.

4. Testing (10%)
Most of the testing work was already covered in the ViewModel implementation phase, as we structured tests based on use cases. In this step, we ensured that all use cases returned the expected data in the correct format.

5. Documentation, Code Cleanup, and Refinement (10%)
Every app has room for improvement. In this final step, we reviewed functionality, performed bug fixes, and made refinements based on testing feedback. We ensured the app behaved as expected before finalizing the project.


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

1. Favorite Button
   Initially considered adding a favorite button to allow users to save recipes. However, without a clear data persistence strategy (local storage or backend sync), implementing this feature now would introduce unnecessary complexity.

2. Offline Support
  Implementing full caching and sync mechanisms adds significant overhead and compromises the project deliverability

3. Optimizing for slow connections:
 We originally started with an skeleton loader/shimmering effect for the image loading but adding this would require additional performance considerations. That's why we focus on the core UI functionality first.

### Weakest Part of the Project: What do you think is the weakest part of your project?

I do think there's few part of the project that could be improved such as: 

* Accessibility: We should always take in mind all the possible user base
* Lack of support for localization.
* UI Is very plain and lacks features that could make the search for recipes easier, such as tagged recipes, favorites or tabs.
* Lack of offline support (Cached response)

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

Yes, one significant constraint was in how we handle malformed recipes.

One of the project requirements states: "If a recipe is malformed, your app should disregard the entire list of recipes."

While I believe that completely discarding all recipes due to a single malformed entry negatively impacts user experience, I decided to adhere to the requirement rather than implementing a more graceful error-handling approach that would allow valid recipes to be displayed.
