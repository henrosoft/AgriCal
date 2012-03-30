from data.util import *

courses = Course.objects.all()
for course in courses:
	if course.title == None:
		course.title = ""
	if course.year == None:
		course.year = ""
	if course.ccn == None:
		course.ccn = ""
	if course.abbreviation == None:
		course.abbreviation = ""
	if course.number == None:
		course.number = ""

	if course.section == None:
		course.section = ""
	if course.type == None:
		course.type = ""
	if course.instructor== None:
		course.instructor= ""
	if course.time== None:
		course.time= ""
	if course.location== None:
		course.location= ""
	if course.units== None:
		course.units= ""
	if course.exam_group== None:
		course.exam_group= ""
	course.save()
