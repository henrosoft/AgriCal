from django.conf.urls.defaults import patterns, include, url
from piston.resource import Resource
from api.handlers import BusLineHandler
from api.handlers import MenuHandler

bus_line_handler = Resource(BusLineHandler)

menu_handler = Resource(MenuHandler)


urlpatterns = patterns('',
		url(r'^line/(?P<line_id>\d+)/$',bus_line_handler),
		url(r'^line/$',bus_line_handler),
		url(r'^menu/(?P<menu_location>\w+)/$',menu_handler),
		url(r'^menu/$',menu_handler),
)
