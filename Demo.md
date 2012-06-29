<a name="title" />
# Windows Azure Web Sites and Cloud Services #

---
<a name="Overview" />
## Overview ##

Windows Azure Web Sites let you build highly scalable web sites on Windows Azure. Quickly and easily deploy sites to a highly scalable cloud environment that allows you to start small and scale as traffic grows. Use the languages and apps of your choice then deploy with FTP, Git and TFS. 

With Windows Azure Cloud Services you can quickly deploy and manage powerful applications and services. Simply upload your application and Windows Azure handles the deployment details - from provisioning and load balancing to health monitoring for continuous availability.

In this demo you will see how to deploy an MVC 4 web application to a Windows Azure Web Site by using the Publish Web wizard in Visual Studio 2012 RC, and then how you can deploy the same application to a Windows Azure Cloud Service by using the Windows Azure SDK for .NET in Visual Studio 2012 RC.

<a name="technologies" />
### Key Technologies ###

- Windows Azure subscription - you can sign up for free trial [here][1]
- [Microsoft Visual Studio 2012 RC][2]
- [Git][3]

[1]: http://bit.ly/WindowsAzureFreeTrial
[2]: http://www.microsoft.com/visualstudio/11/en-us
[3]: http://go.microsoft.com/fwlink/?LinkID=251797&clcid=0x409

<a name="setup" />
### Setup and Configuration ###

In order to execute this demo you need to set up your environment.

1. Open Windows Explorer and browse to the demo's **Source** folder.

1. Run the **Setup.Local.cmd** script as an administrator.

> **Note:** The setup script creates a new folder that can be configured in the **Config.Local.xml** file (by default, C:\Projects) and sets this folder as the default for the Visual Studio New Project dialog.

<a name="Demo" />
## Demo ##

<a name="segment1" />
### Creating a new  Web Site ###

1. In Windows Azure Management Portal, click **New** in the bottom menu, select **Web Site** and then **Quick Create**.

	> 	**Speaking Point:** 
	>
	Now I will show you how to create a new Web Site using the Windows Azure Management Portal. You will see how fast the site gets created.

1. Enter the url for the new site and click **Create Web Site**.

	![Creating a new Web Site](images/creating-a-new-web-site.png?raw=true "Creating a new Web Site")

	_Creating a new Web Site_

1. Once the site is provisioned, click on its url to navigate to the default page.

	> **Speaking point:** 
	>
	As you can see it takes just a few seconds to create the new Web Site. I will now navigate to the site's default page to show that it is totally operative.

	![The provisoned site](images/the-provisoned-site.png?raw=true "The provisoned site")

	_The provisoned site_

	![The new site's default page](images/the-new-sites-default-page.png?raw=true "The new site's default page")

	_The new site's default page_

1. In Windows Azure Management Portal go to **Web Sites** and click the name of the web site you just created.

	> **Speaking Point:** 
	>
	Now I will get back to Windows Azure and go to the site's Dashboard in order to download the Publish Profile. We will use this to deploy applications to our Web Site.

1. Once in the **Dashboard** page, click the **Download publis profile** link and then click "Save" in the dialog that appears

	![Downloading publish profile](images/downloading-publish-profile.png?raw=true "Downloading publish profile")

	_Downloading publish profile_

1. In Windows 8 start menu search for **Visual Studio 2012** and execute it elevated by right clicking the Visual Studio Icon and selecting **Run as administrator**.

	> **Speaking Point:** 
	>
	Now I'll go to Visual Studio and create a new MVC 4 internet application and deploy it to our web site. I will use web deploy to deploy the site. You will see how fast it deploys.

1. In Visual Studio, select **File | New | Project** from the main menu.

1. In the **New Project** dialog, select **C# | Web** under templates and then select **ASP.NET MVC 4 Web Application** in the right pane. Enter a name for the application and then click **Ok**.

	![Creating new MVC 4 application](images/creating-new-mvc-4-application.png?raw=true "Creating new MVC 4 application")

	_Creating new MVC 4 application_

1. In the **New ASP.NET MVC 4** project dialog, select **Internet Application** and then click **Ok**.

	![Selecting the Internet Application template](images/selecting-the-internet-application-template.png?raw=true "Selecting the Internet Application template")

	_Selecting the Internet Application template_

1. Make sure the target framework of the project is 4.0. Right click the project's name and select **Publish**.

1. In the "Publish Web" dialog, click the **Import** button and select the publish profile file you donwloaded from Management Portal. The necessary publish data will be completed. Click **Publish** to start the publishing process.

	> **Speaking Point:** 
	>
	Now we will publish the MVC4 site to our Web Site to see it running in the cloud.

	![Publishing the website](images/publishing-the-website.png?raw=true "Publishing the website")

	_Publishing the website_

1. Once the publish process is finished the web site page will be loaded.

	![The new site loaded](images/the-new-site-loaded.png?raw=true "The new site loaded")

	_The new site loaded_

1. Go Back to Windows Azure Management Portal. In the web site's dashboard, click **Set up Git publishing**.

	> **Speaking point:** 
	>
	Now we will enable GitHub publishing and will see how we can publish new updates using git.

	![Setting up git publishing](images/setting-up-git-publishing.png?raw=true "Setting up git publishing")

	_Setting up git publishing_

1. Go back to Visual Studio and open the **HomeController.cs" file under the **Controllers** folder.

1. Update the index method as shown below

	<!-- mark:3-5 -->
	````C#
public ActionResult Index()
{
		ViewBag.Message = "Hello World";

		Return View();
}
````

1. Save the **HomeController.cs** file and buid the solution by hitting **F6**

1. If not already installed, download and install [Git](http://go.microsoft.com/fwlink/?LinkID=251797&clcid=0x409)

1. Open **Git Bash** or a **Command Prompt** window (depending on your Git installation) and run the following commands.

	````CMDPROMPT
git init 
git add . 
git commit -m "initial commit"
git remote add azure [YOUR SERVER GIT REMOTE ADDRESS] 
git push azure master
````

1. Go back to the web site page and hit **F5** to refresh the page. Note that the message has changed to **Hello World**.

	![The updated Site](images/the-updated-site.png?raw=true "The updated Site")

	_The updated Site_

1. In Windows Azure portal, go the website's dashboard and select **Scale**.

	![Selecting Scale options](images/selecting-scale-options.png?raw=true "Selecting Scale options")

	_Selecting Scale options_

1. Once in the **Scale** page, show the audience the scaling options.

	![Web Site scaling options](images/web-site-scaling-options.png?raw=true "Web Site scaling options")

	_Web Site scaling options_

	> **Speaking point:** 
	>
	Here we can manage the scaling options of our web site, such as  the Web Site mode wich could be Shared or Reserved .In Shared mode, all web sites share the servers and are created in the same geographical-region; In Reserved mode implies that all web sites in a given region run on dedicated virtual machines. Reserved mode provides your sites more processing power and performance and allows you to scale your instance count and size. Also we can change the Shared Instance count, denotes the number of processes dedicated to a web site. By changing this setting, you can scale out your web site for increased throughput and availability. Similarly, we can adjust the Instance size and Instance count for reserved mode.

	> **Speaking Point:** 
	>
	Now we will see how we can publish our Web Site as a **Cloud Service** in **Windows Azure**

1. Go back to Visual Studio. In Solution Explorer right click the **NewAzureWebSite** project and select 
**Add Windows Azure Cloud Service Project**.

	![Adding a Cloud Service Project](images/adding-a-cloud-service-project.png?raw=true "Adding a Cloud Service Project")

	_Adding a Cloud Service Project_

1. Hit **F5** to run the solution in **Windows Azure Emulator**.

	![Running application in Windows Azure Emulator](images/running-application-in-windows-azure-emulator.png?raw=true "Running application in Windows Azure Emulator")

	_Running application in Windows Azure Emulator_

1. Close the browser.

1. In Solution Explorer, right click **Roles** and select **Add | New Worker Role Project**.

1. In the **Add New Role Project** dialog, select **Worker Role**, set the name to **BackgroundService** and click **Add**.

	![Adding a Worker Role](images/adding-a-worker-role.png?raw=true "Adding a Worker Role")

	_Adding a Worker Role_

1. Right click the **BackgroundService** worker role and select **Properties**

1. Select the **Configuration** tab and set the **Instance Count** to **2**.

	![Increasing the Worker Role instance count](images/increasing-the-worker-role-instance-count.png?raw=true "Increasing the Worker Role instance count")

	_Increasing the Worker Role instance count_

1. Repeat the previous step for the Web Role.

1. Hit **F5** to run the application.

1. Right click the Cloud Service project and select **Publish**

1. You may need to download the **Publish Settings** file. To do so, click the **Sing in to download credentials** link and sing in using your credentials. Once you are signed in donwload the Publish Settings file.

	![Downloading Publish Settings](images/downloading-publish-settings.png?raw=true "Downloading Publish Settings")

	_Downloading Publish Settings_

1. Click the **Publish** button to start the publish process.

1. Wait until the publish process finishes.

	![Completed Deployment](images/completed-deployment.png?raw=true "Completed Deployment")

	_Completed Deployment_

1. In Windows Azure portal, go to **Cloud Services** and click the name of the cloud service where you deployed the MVC4 site.

1. Once in the Dashboard page, click on the **Site URL** to load the site.

	![Storage Account Dashboard](images/storage-account-dashboard.png?raw=true "Storage Account Dashboard")

	_Storage Account Dashboard_

1. Wait for the site to load. Check that the MVC site is running in Windows Azure.

	![The site running in the cloud](images/the-site-running-in-the-cloud.png?raw=true "The site running in the cloud")

	_The site running in the cloud_

1. In Windows Azure portal, go to the cloud service's dashboard. Then go to **Configure** tab and show the audience the monitoring options.
	
	![Storage Account monitoring options](images/storage-account-monitoring-options.png?raw=true "Storage Account monitoring options")

	_Cloud Service monitoring options_

1. Now go to the **Scale** tab and show how the role instances can be updated.

	![Cloud Service scale options](images/cloud-service-scale-options.png?raw=true "Cloud Service scale options")

	_Cloud Service scale options_

	