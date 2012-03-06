from piston.handler import BaseHandler
from data.models import *

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
