# Create your views here.

from data.util import *
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt
def enrollment(request,ccn):
	return HttpResponse(enrollment_info(ccn))
@csrf_exempt
def balance(request):
	try:
		if request.method=="GET":
			username = request.GET['username']
			password = request.GET['password']
			return HttpResponse("[" + get_cal_balance(username,password) + "]")
		if request.method=="POST":
			username = request.POST['username']
			password = request.POST['password']
			return HttpResponse("[" + get_cal_balance(username,password) + "]")
	except:
		return HttpResponse("[-1]")

def schedule(request):
	try:
		if request.method=="GET":
			username = request.GET['username']
			password = request.GET['password']
			return HttpResponse(str(get_schedule(username,password)))
		if request.method=="POST":
			username = request.POST['username']
			password = request.POST['password']
			return HttpResponse(str(get_schedule(username,password)))
	except:
		return HttpResponse("[-1]")
