from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from api.handlers import * 

bus_line_handler = Resource(BusLineHandler)

menu_handler = Resource(MenuHandler)
dining_time_handler = Resource(DiningTimeHandler)
course_handler = Resource(CourseHandler)
course_department_handler = Resource(CourseDepartmentHandler)
#course_schedule_handler = Resource(ScheduleHandler)
course_webcast_handler = Resource(WebcastHandler)


urlpatterns = patterns('',
		#Bus
		url(r'^line/(?P<line_id>\d+)/$',bus_line_handler),
		url(r'^line/$',bus_line_handler),

		#Menu
		url(r'^menu/(?P<menu_location>\w+)/$',menu_handler),
		url(r'^menu/$',menu_handler),
		url(r'^dining_times/$',dining_time_handler),

		#courses
		url(r'^courses/$',course_handler),
		url(r'^schedule/$',course_handler),
		url(r'^courses/(?P<department_id>\d+)/$',course_handler),
		url(r'^courses/(?P<department>\w+)/$',course_handler),
		url(r'^enrollment/(?P<ccn>\d+)/$','api.views.enrollment'),

		#cal one card
		url(r'^balance/$',"api.views.balance"),

		#webcasts
		url(r'^webcasts/$',course_webcast_handler),
		url(r'^webcasts/(?P<course_id>\d+)/$',course_webcast_handler,name="course_webcasts"),
)
