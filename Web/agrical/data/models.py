from django.db import models
from django.contrib import admin

import BeautifulSoup
import urllib


class BusVehicle(models.Model):
	vehicle_id = models.IntegerField()
	route_tag = models.CharField(max_length=10)
	dir_tag = models.CharField(max_length=10,null=True)
	latitude = models.FloatField()
	longitude = models.FloatField()
	seconds_since_report = models.IntegerField()
	predictable = models.BooleanField()
	heading = models.FloatField()
	speed = models.FloatField()

class BusLine(models.Model):
	vehicles = models.ManyToManyField(BusVehicle)
	line_title = models.CharField(max_length = 50)
	line_tag = models.CharField(max_length = 50)

	def update(self):
		url = "http://webservices.nextbus.com/service/publicXMLFeed?command=vehicleLocations&a=actransit&r=1&t=1330150116620"
		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())
		vs = soup.findAll("vehicle")
		for v in vs:
			print v
			b = BusVehicle()
			b.vehicle_id = v['id']
			try:
				b.route_tag = v['routetag']
			except:
				b.route_tag = "51B"
			try:
				b.dir_tag = v['dirtag']
			except:
				b.dir_tag = None
			b.latitude = v['lat']
			b.longitude = v['lon']
			b.seconds_since_report = v['secssincereport']
			b.predictable = v['predictable']
			b.heading = v['heading']
			b.speed = v['speedkmhr']
			b.save()
			self.vehicles.add(b)
	




class MenuItem(models.Model):
	name = models.CharField(max_length=200)
	type = models.CharField(max_length=50,default="Normal")

class Menu(models.Model):
	location = models.CharField(max_length=50)
	breakfast = models.ManyToManyField(MenuItem,related_name="breakfast")
	lunch = models.ManyToManyField(MenuItem,related_name="lunch")
	brunch = models.ManyToManyField(MenuItem,related_name="brunch")
	dinner = models.ManyToManyField(MenuItem,related_name="dinner")

	def update(self):
		url = "http://services.housing.berkeley.edu/FoodPro/dining/static/todaysentrees.asp"
		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())
		index = 0
		if self.location == "crossroads":
			index = 0
		elif self.location == "cafe3":
			index = 1
		elif self.location == "foothill":
			index = 2
		elif self.location == "ckc":
			index = 3
	
		breakfast = soup.find("table").find("tbody").findAll("tr",recursive=False)[1].find("table").findAll("tr",recursive=False)[1].findAll("td")[index].findAll("a")
		lunch = soup.find("table").find("tbody").findAll("tr",recursive=False)[1].find("table").findAll("tr",recursive=False)[2].findAll("td")[index].findAll("a")
		dinner = soup.find("table").find("tbody").findAll("tr",recursive=False)[1].find("table").findAll("tr",recursive=False)[3].findAll("td")[index].findAll("a")
		for i in breakfast:
			if i.find("font"):
				m = MenuItem()
				m.name = i.find("font").contents[0]
				m.save()
				self.breakfast.add(m)
		for i in lunch:
			if i.find("font"):
				m = MenuItem()
				m.name = i.find("font").contents[0]
				m.save()
				self.lunch.add(m)
		for i in dinner:
			if i.find("font"):
				m = MenuItem()
				m.name = i.find("font").contents[0]
				m.save()
				self.dinner.add(m)
# Create your models here.

admin.site.register(BusLine)
admin.site.register(BusVehicle)
admin.site.register(MenuItem)
admin.site.register(Menu)
