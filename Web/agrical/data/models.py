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
	link = models.CharField(max_length=1000,default="#")
	pub_date = models.DateTimeField(auto_now_add=True)

class Menu(models.Model):
	location = models.CharField(max_length=50)
	breakfast = models.ManyToManyField(MenuItem,related_name="breakfast")
	lunch = models.ManyToManyField(MenuItem,related_name="lunch")
	brunch = models.ManyToManyField(MenuItem,related_name="brunch")
	dinner = models.ManyToManyField(MenuItem,related_name="dinner")
	pub_date = models.DateTimeField(auto_now_add=True)

	def update(self):
		base = "http://services.housing.berkeley.edu/FoodPro/dining/static/"
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
		soup_key = soup.find("table").find("tbody").findAll("tr",recursive=False)[0].findAll("td",recursive=False)[1].find("table").find("table").findAll("font")
		key = {u'#000000':"Normal"}
		for i in soup_key[1:4]:
			key[i['color']] = i.contents[0]
		print key

		for i in breakfast:
			if i.find("font"):
				m = MenuItem()
				m.link = base + i['href']
				m.name = i.find("font").contents[0]
				try:
					m.type = key[i.find("font")['color']]
				except:
					pass
				m.save()
				self.breakfast.add(m)
		for i in lunch:
			if i.find("font"):
				m = MenuItem()
				m.link = base + i['href']
				m.name = i.find("font").contents[0]
				try:
					m.type = key[i.find("font")['color']]
				except:
					pass
				m.save()
				self.lunch.add(m)
		for i in dinner:
			if i.find("font"):
				m = MenuItem()
				m.link = base + i['href']
				m.name = i.find("font").contents[0]
				try:
					m.type = key[i.find("font")['color']]
				except:
					pass
				m.save()
				self.dinner.add(m)
	class Meta:
		ordering = ['-pub_date']

class TimeSpan(models.Model):
	days = models.CharField(max_length=50)
	type = models.CharField(max_length=50)
	span = models.CharField(max_length=50)
class Location(models.Model):
	location = models.CharField(max_length=50) 
	timespans = models.ManyToManyField(TimeSpan)
def clean(s):
	s2 = s
	s2 = s2.replace("<strong>","")
	s2 = s2.replace("</strong>","")
	s2 = s2.replace("<p>","")
	s2 = s2.replace("</p>","")
	s2 = s2.replace("\n","")
	s2 = s2.replace("&amp;","&")
	s2 = s2.replace("&nbsp;","")
	s2 = s2.replace("&#160;","")
	s2 = s2.replace("...","")
	return s2.strip()

class DiningTime(models.Model):
	locations = models.ManyToManyField(Location)
	pub_date = models.DateTimeField(auto_now_add=True)

	def update(self):
		url = "http://caldining.berkeley.edu/hours.html"
		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())

		#crossroads
		def addLocation(name,ls):
			times = str(ls[0]).split("<br />")
			l = Location()
			l.location = name
			l.save()

			for i in range(1,len(times)):
				ts = TimeSpan()
				ts.days = clean(times[0])
				ts.type = clean(times[i].split(" ")[0])
				ts.span = clean(''.join(times[i].split()[1:]))
				ts.save()
				l.timespans.add(ts)
				l.save()
			l.save()

			times = str(ls[1]).split("<br />")

			for i in range(1,len(times)):
				ts = TimeSpan()
				ts.days = clean(times[0])
				ts.type = clean(times[i].strip().split(" ")[0])
				ts.span = clean(''.join(times[i].split()[1:]))
				ts.save()
				l.timespans.add(ts)
				l.save()
			l.save()
			self.locations.add(l)
			self.save()
		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[3].find("td").findAll("p")
		addLocation("crossroads",ls)

		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[3].findAll("td",recursive=False)[1].findAll("p")
		addLocation("ckc",ls)

		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[8].findAll("td",recursive=False)[0].findAll("p")
		addLocation("cafe3",ls)

		ls = soup.find("table").findAll("tr",recursive=False)[1].findAll("td",recursive=False)[1].find("table").findAll("tr",recursive=False)[8].findAll("td",recursive=False)[1].findAll("p")
		addLocation("foothill",ls)

		self.save()

	class Meta:
		ordering = ['-pub_date']

class Course(models.Model):
	semester = models.CharField(max_length=30,default="Spring")
	year = models.CharField(max_length=20,null=True)
	ccn = models.CharField(max_length=20,null=True)
	abbreviation = models.CharField(max_length=50,null=True)
	number = models.CharField(max_length=50,null=True)
	section = models.CharField(max_length=20,null=True)
	type = models.CharField(max_length=20,null=True)
	title = models.CharField(max_length=500,null=True)
	instructor = models.CharField(max_length=100,null=True)
	time = models.CharField(max_length=100,null=True)
	location = models.CharField(max_length=100,null=True)
	units = models.CharField(max_length=20,null=True)
	exam_group = models.CharField(max_length=20,null=True)


# Create your models here.

admin.site.register(BusLine)
admin.site.register(BusVehicle)
admin.site.register(MenuItem)
admin.site.register(Menu)
admin.site.register(DiningTime)
admin.site.register(Location)
admin.site.register(TimeSpan)
admin.site.register(Course)
