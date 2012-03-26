from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from api.handlers import * 

bus_line_handler = Resource(BusLineHandler)

menu_handler = Resource(MenuHandler)
dining_time_handler = Resource(DiningTimeHandler)
course_handler = Resource(CourseHandler)


urlpatterns = patterns('',
		url(r'^line/(?P<line_id>\d+)/$',bus_line_handler),
		url(r'^line/$',bus_line_handler),

		#Menu
		url(r'^menu/(?P<menu_location>\w+)/$',menu_handler),
		url(r'^menu/$',menu_handler),
		url(r'^dining_times/$',dining_time_handler),

		#courses
		url(r'^courses/$',course_handler),
)
