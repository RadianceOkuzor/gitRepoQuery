# gitRepoQuery
Hello World

This is a small iPhone application that queries Github to get repositories that mention GraphQL. The results are displayed in a list view with pagination support. 

# Key Features
Pagination 
Custom Font 
Animation
Aribtrary Cell Sizing
MVVM Architecture 
Class Extension
Custom Class
API Calls
Code Testing 
Singleton
Search 
Filter
Caching/working with or without wifi**

# Getting Started
Launch the app and immediately you see cells showing you queries for graphql in the cell you will be able to see the name of the repo, the owner login name, the avater, and the number of stars.
from here you will observe that you can either paginate to 30 more rows, filter repos by starrs, watchers or forks, or go into the row and get more data.
when you click on the row to get more data you will see an animation of the graph of the amount of starrs watchers and forks the user has for his repository, which could potentially add to his/her credibility of work.

$ Diving deep
The app starts with the ListOfReposTableVC from where RepoViewModel() class is initialized, upon initailization it uses the api class to hit the git hub api to make a request with the preset search "graphql" using alamo fire for it's ubiquitous interface. upon coming back with a response it initializes the RepoListDTO object which is a computed variable to performs the function which it's binded to by the calling class. this then reverts back to the ListOfRepos class where the RepoListDTO object is ready to receive the response and populate the array. 
when you click on the cell it takes you deeper to show more info on that repo and user.

# What I Would Do With More Time
1) I would clean up the UI A lot
2) I would do a lot more tests
3) I would do handle the API response errors alot better
4) I would debug for more edge cases, the app works when used as expected^^


