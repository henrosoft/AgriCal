from data.models import *
import BeautifulSoup
import urllib

import mechanize

def update_course_data():
		br = mechanize.Browser()

		url = "http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y"

		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())
		classes = soup.find("table").find("table").findAll("tr")
		classes = classes[2:len(classes)]
		for c in classes:
			terms = c.findAll("label")
			if len(terms)==3:
				try:
					c = Course.objects.get(semester="Spring",year=2012,number=clean(terms[1].contents[0]),abbreviation=clean(terms[0].contents[0]))
				except:
					br.open(url)
					br.select_form(nr=0)
					br.form.set_all_readonly(False)

					c = Course()
					c.semester = "Spring"
					c.year = 2012
					try:
						c.abbreviation = clean(terms[0].contents[0])
					except:
						pass
					try:
						c.number = clean(terms[1].contents[0])
					except:
						pass
					try:
						c.title = clean(terms[2].contents[0])
					except:
						pass


					try:
						br['p_dept'] = c.abbreviation
					except:
						br['p_dept'] = ""
					try:
						br['p_course'] = c.number
					except:
						br['p_course'] = ""
					try:
						br['p_title'] = c.title
					except:
						br['p_title'] = ""
					print c.title
					subsoup = BeautifulSoup.BeautifulSoup(br.submit().read())
					table = subsoup.findAll("table")[1]
					try:
						c.ccn = clean(table.findAll("tr")[5].findAll("td")[1].find("tt").contents[0])
					except:
						pass
					try:
						c.instructor = clean(table.findAll("tr")[3].findAll("td")[1].find("tt").contents[0])
					except:
						pass
					try:
						l = clean(table.findAll("tr")[2].findAll("td")[1].find("tt").contents[0])
						t, l = l.split(',')
						c.time = t.strip()
						c.location = l.strip()
					except:
						pass
					try:
						c.units = clean(table.findAll("tr")[6].findAll("td")[1].find("tt").contents[0])
					except:
						pass
					try:
						c.exam_group = clean(table.findAll("tr")[7].findAll("td")[1].find("tt").contents[0])
					except:
						pass
					c.save()
