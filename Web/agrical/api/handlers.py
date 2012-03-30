from piston.handler import BaseHandler
from data.models import *
from data.util import *


class CourseHandler(BaseHandler):
	allowed_methods = ("GET",)
	model = Course
	fields = ('id','webcast','semester','year','ccn','abbreviation','number','section','type','title','instructor','time','location','units','exam_group','days','pnp','sections','limit','enrolled','waitlist','available_seats')

	def read(self,request,department=None,department_id=None):
		if 'username' in request.GET and 'password' in request.GET:
			username = request.GET['username']
			password = request.GET['password']
			return get_schedule(username,password)
		elif department_id:
			return Course.objects.filter(id=department_id)
		elif department:
			if department == "departments":
				d = set()
				for course in Course.objects.all():
					d.add((course.abbreviation,0))
				return list(d) 
			return Course.objects.filter(abbreviation=department)
		return Course.objects.all()
class WebcastHandler(BaseHandler):
	allowed_methods = ("GET",)
	model = Webcast

	def read(self,request,course_id=None):
		if course_id:
			c = Course.objects.get(id=course_id)
			all_webcasts = Webcast.objects.all()
			these_webcasts = []
			for w in all_webcasts:
				if w.description and w.description in c.title:
					these_webcasts.append(w)
			return these_webcasts
		else:
			return Webcast.objects.all()
class CourseDepartmentHandler(BaseHandler):
	allowed_methods = ("GET",)
	model = BusVehicle 

	def read(self,request):
		departments = set()
		for course in Course.objects.all():
			departments.add(course.abbreviation)
		return list(departments) 

class BusLineHandler(BaseHandler):
	allowed_methods = ("GET",)
	model = BusLine
	fields = ('line_title','line_tag','vehicles')

	def read(self,request, line_id=None):
		if line_id:
			return BusLine.objects.get(id=line_id)
		else:
			return BusLine.objects.all()

class MenuHandler(BaseHandler):
	allowed_methods = ("GET",)
	model = Menu
	fields = ('location','breakfast','lunch','brunch','dinner')

	def read(self,request, menu_location=None):

		if menu_location:
			try:
				m = Menu.objects.filter(location=menu_location)[0]
				import datetime
				if datetime.datetime.now().date()==m.pub_date.date():
					return Menu.objects.filter(location=menu_location)[0]
				else:
					pass
			except:
				pass
			m = Menu()
			m.location = menu_location
			m.save()
			m.update()
			return m
		else:
			return Menu.objects.all()

class DiningTimeHandler(BaseHandler):
	allowed_methods = ("GET",)
	model = DiningTime
	fields = (('timespans',('days','type','span')),)
	def read(self,request):
		dt = None
		try:
			dt = DiningTime.objects.all()[0]
			import datetime
			if datetime.datetime.now().date()==m.pub_date.date():
				dt.update()
				dt.save()
			else:
				dt = None
		except:
			pass
		if dt == None:
			dt = DiningTime()
			dt.save()
			dt.update()
		l = {}
		l["pub_date"] = dt.pub_date
		for location in dt.locations.all():
			l[location.location] = location
		return l 
