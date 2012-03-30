from data.models import *
import BeautifulSoup
import urllib

import mechanize
def scrape_class(c):
	import urllib
	import mechanize
	import urllib2
	import BeautifulSoup
	br = mechanize.Browser()
	url = "http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y"
	terms = c.findAll("label")
	if len(terms)==3:
		try:
			c = Course.objects.get(semester="Spring",year=2012,number=clean(terms[1].contents[0]),abbreviation=clean(terms[0].contents[0]))
		except:
			c = Course()

		br.open(url)
		br.select_form(nr=0)
		br.form.set_all_readonly(False)

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
		try:
			info = clean(table.findAll("tr")[10].findAll("td")[1].find("tt").contents[0]).split()
			c.limit = info[0].split(":")[-1]
			c.enrolled = info[1].split(":")[-1]
			c.waitlist = info[2].split(":")[-1]
			c.available_seats = info[-1].split(":")[-1]
		except:
			pass
		c.save()
		c.sections = []
		tables = subsoup.findAll("table")
		for i in tables[1:len(tables)]:
			try:
				ccn,i,t,l,u,e,type,limit,enrolled,waitlist,available_seats = get_course_table_info(i) 
				if type.split()[-1]=="LEC":
					old = c
					try:
						c = Course.objects.get(ccn=ccn)
					except:
						c = Course()
					c.year = 2012
					c.abbreviation = old.abbreviation 
					c.title = old.title + " " + type.split()[-2]
					c.number = old.number
					c.ccn = ccn
					c.instructor = i
					c.time = t
					c.location = l
					c.units = u
					c.exam_group = e

					c.limit = limit
					c.waitlist = waitlist
					c.enrolled = enrolled
					c.available_seats = available_seats
				else:
					s = None
					try:
						s = Section.objects.get(ccn=ccn)
					except:
						s = Section()
					s.ccn = ccn
					s.instructor = i
					s.time = t
					s.location = l
					s.units = u
					s.exam_group = e
					s.type = type.split()[-1]

					s.limit = limit
					s.waitlist = waitlist
					s.enrolled = enrolled
					s.available_seats = available_seats
					s.save()

					c.sections.add(s)

				c.save()
			except:
				pass
def get_course_table_info(table):
	li = [] # [ccn,instructor,time,location,units,exam_group,type,limit,enrolled,waitlist,available_seats]
	ok = False
	try:
		li.append(clean(table.findAll("tr")[5].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[3].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		l = clean(table.findAll("tr")[2].findAll("td")[1].find("tt").contents[0])
		t, l = l.split(',')
		li.append(t.strip())
		li.append(l.strip())
		ok = True
	except:
		li.append("")
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[6].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[7].findAll("td")[1].find("tt").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		li.append(clean(table.findAll("tr")[0].findAll("td")[2].find("b").contents[0]))
		ok = True
	except:
		li.append("")
	try:
		info = clean(table.findAll("tr")[10].findAll("td")[1].find("tt").contents[0]).split()
		li.append(info[0].split(":")[-1])
		li.append(info[1].split(":")[-1])
		li.append(info[2].split(":")[-1])
		li.append(info[-1].split(":")[-1])
		ok = True
	except:
		li.append("")
		li.append("")
		li.append("")
		li.append("")
	if ok:
		return li
	else:
		raise Exception()


def update_course_data():
		br = mechanize.Browser()

		url = "http://osoc.berkeley.edu/OSOC/osoc?p_term=SP&p_list_all=Y"

		response = urllib.urlopen(url)
		soup = BeautifulSoup.BeautifulSoup(response.read())
		classes = soup.find("table").find("table").findAll("tr")
		classes = classes[2:len(classes)]
		import threading
		import sys
		import signal
		def timeout_handler(signum, frame):
			raise TimeoutException()
		for c in classes:
			p = False
			count = 0
			while not p and count<3:
				signal.signal(signal.SIGALRM, timeout_handler)
				signal.alarm(10)
				try:
					scrape_class(c)
					p = True
				except:
					print "Timeout...."
					print "Trying class again..."
					count += 1

def get_cal_balance(username,password):
	from twill.commands import *
	import twill

	b = twill.get_browser() # make it so that twill can handle xhtml
	b._browser._factory.is_html = True
	twill.browser = b

	b.clear_cookies()
	b.go("https://services.housing.berkeley.edu/c1c/dyn/balance.asp")
	try:
		fv("1","username",username)
		fv("1","password",password)
		submit('0')
		submit('0')
	except:
		pass
	b.go("https://services.housing.berkeley.edu/c1c/dyn/balance.asp")
	soup = BeautifulSoup.BeautifulSoup(show())
	balance = soup.find("table").findAll("tr")[4].find("td").find("b").contents[0]
	return balance

def get_schedule(username,password):
	from twill.commands import *
	import twill

	b = twill.get_browser() #  make it so that twill can handle xhtml  
	b._browser._factory.is_html = True
	twill.browser = b

	config("acknowledge_equiv_refresh",0) #turn of redirection i think... (https://twill.jottit.com/command)

	b.clear_cookies()
	b.go("https://bearfacts.berkeley.edu/bearfacts/student/registration.do?bfaction=displayClassSchedules&termStatus=CT")
	try:
		fv("1","username",username)
		fv("1","password",password)
		submit('0')
		submit('0')
	except:
		pass
	b.go("https://bearfacts.berkeley.edu/bearfacts/student/registration.do?bfaction=displayClassSchedules&termStatus=CT")
	soup = BeautifulSoup.BeautifulSoup(show())
	classes = soup.find("div",{"class":"main-content-div"}).findAll("table",width="100%")[0].findAll("tr")
	cs = [] 
	header = [c.contents[0] for c in classes[0].findAll("th")]
	for c in classes[1:len(classes)]:
		try:
			tmp = Course.objects.get(ccn=clean(str(c.findAll("td")[0].contents[0])))
			cs.append(tmp)
		except:
			"""
			tmp = Course()
			tmp.ccn = clean(str(c.findAll("td")[0].contents[0])) 
			tmp.abbreviation = clean(str(c.findAll("td")[1].contents[0])) 
			tmp.number = clean(str(c.findAll("td")[2].contents[0])) 
			tmp.type = clean(str(c.findAll("td")[3].contents[0])) 
			tmp.section = clean(str(c.findAll("td")[4].contents[0])) 
			tmp.title = clean(str(c.findAll("td")[5].contents[0])) 
			tmp.instructor = clean(str(c.findAll("td")[6].contents[0])) 
			tmp.pnp = clean(str(c.findAll("td")[7].contents[0])) 
			tmp.units = clean(str(c.findAll("td")[8].contents[0])) 
			tmp.days = clean(str(c.findAll("td")[9].contents[0])) 
			tmp.time = clean(str(c.findAll("td")[10].contents[0])) 
			tmp.location = clean(str(c.findAll("td")[11].contents[0])) 
			"""
	return cs 

def update_webcast_data():
	from gdata.youtube.service import *
	yt_service = gdata.youtube.service.YouTubeService()
	playlist_feed = yt_service.GetYouTubePlaylistFeed(username='ucberkeley')
	for video_entry in playlist_feed.entry:
		playlist_video_feed = yt_service.GetYouTubePlaylistVideoFeed(uri='http://gdata.youtube.com/feeds/api/playlists/' + video_entry.id.text.split("/")[-1])
		for entry in playlist_video_feed.entry:
			w = Webcast()
			t = entry.title.text.split(" - ")
			try:
				w.title = t[0]
			except:
				pass
			try:
				w.number = t[1].split()[1].replace(":","")
			except:
				pass

			w.description = entry.description.text
			w.url = entry.media.content[0].url
			w.save()
def enrollment_info(ccn):
	url = "http://osoc.berkeley.edu/OSOC/osoc?y=1&p_ccn=" + ccn + "&p_term=SP&p_deptname=--+Choose+a+Department+Name+--&p_classif=--+Choose+a+Course+Classification+--&p_presuf=--+Choose+a+Course+Prefix%2fSuffix+--&x=67"
	br = mechanize.Browser()
	try:
		br.open(url)
		br.select_form(nr=2)
		soup = BeautifulSoup.BeautifulSoup(br.submit().read())
		return clean(soup.find("blockquote").contents[0])
	except:
		br.open(url)
		br.select_form(nr=3)
		soup = BeautifulSoup.BeautifulSoup(br.submit().read())
		return clean(soup.find("blockquote").contents[0])
	
