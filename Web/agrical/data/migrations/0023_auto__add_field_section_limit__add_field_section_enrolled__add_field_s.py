# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding field 'Section.limit'
        db.add_column('data_section', 'limit', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Section.enrolled'
        db.add_column('data_section', 'enrolled', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Section.waitlist'
        db.add_column('data_section', 'waitlist', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Section.available_seats'
        db.add_column('data_section', 'available_seats', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Course.limit'
        db.add_column('data_course', 'limit', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Course.enrolled'
        db.add_column('data_course', 'enrolled', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Course.waitlist'
        db.add_column('data_course', 'waitlist', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)

        # Adding field 'Course.available_seats'
        db.add_column('data_course', 'available_seats', self.gf('django.db.models.fields.CharField')(default='', max_length=10, null=True), keep_default=False)


    def backwards(self, orm):
        
        # Deleting field 'Section.limit'
        db.delete_column('data_section', 'limit')

        # Deleting field 'Section.enrolled'
        db.delete_column('data_section', 'enrolled')

        # Deleting field 'Section.waitlist'
        db.delete_column('data_section', 'waitlist')

        # Deleting field 'Section.available_seats'
        db.delete_column('data_section', 'available_seats')

        # Deleting field 'Course.limit'
        db.delete_column('data_course', 'limit')

        # Deleting field 'Course.enrolled'
        db.delete_column('data_course', 'enrolled')

        # Deleting field 'Course.waitlist'
        db.delete_column('data_course', 'waitlist')

        # Deleting field 'Course.available_seats'
        db.delete_column('data_course', 'available_seats')


    models = {
        'data.busline': {
            'Meta': {'object_name': 'BusLine'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'line_tag': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'line_title': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'vehicles': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.BusVehicle']", 'symmetrical': 'False'})
        },
        'data.busvehicle': {
            'Meta': {'object_name': 'BusVehicle'},
            'dir_tag': ('django.db.models.fields.CharField', [], {'max_length': '10', 'null': 'True'}),
            'heading': ('django.db.models.fields.FloatField', [], {}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'latitude': ('django.db.models.fields.FloatField', [], {}),
            'longitude': ('django.db.models.fields.FloatField', [], {}),
            'predictable': ('django.db.models.fields.BooleanField', [], {'default': 'False'}),
            'route_tag': ('django.db.models.fields.CharField', [], {'max_length': '10'}),
            'seconds_since_report': ('django.db.models.fields.IntegerField', [], {}),
            'speed': ('django.db.models.fields.FloatField', [], {}),
            'vehicle_id': ('django.db.models.fields.IntegerField', [], {})
        },
        'data.course': {
            'Meta': {'object_name': 'Course'},
            'abbreviation': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '50', 'null': 'True'}),
            'available_seats': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'ccn': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'days': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'enrolled': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'exam_group': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'instructor': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'limit': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'number': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '50', 'null': 'True'}),
            'pnp': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'section': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'sections': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.Section']", 'symmetrical': 'False'}),
            'semester': ('django.db.models.fields.CharField', [], {'default': "'Spring'", 'max_length': '30', 'null': 'True'}),
            'time': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '500', 'null': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'units': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'waitlist': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'year': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'})
        },
        'data.diningtime': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'DiningTime'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'locations': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.Location']", 'symmetrical': 'False'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'data.location': {
            'Meta': {'object_name': 'Location'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'timespans': ('django.db.models.fields.related.ManyToManyField', [], {'to': "orm['data.TimeSpan']", 'symmetrical': 'False'})
        },
        'data.menu': {
            'Meta': {'ordering': "['-pub_date']", 'object_name': 'Menu'},
            'breakfast': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'breakfast'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'brunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'brunch'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'dinner': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'dinner'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'lunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'lunch'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'})
        },
        'data.menuitem': {
            'Meta': {'object_name': 'MenuItem'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'link': ('django.db.models.fields.CharField', [], {'default': "'#'", 'max_length': '1000'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'pub_date': ('django.db.models.fields.DateTimeField', [], {'auto_now_add': 'True', 'blank': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "'Normal'", 'max_length': '50'})
        },
        'data.section': {
            'Meta': {'object_name': 'Section'},
            'available_seats': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'ccn': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'enrolled': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'exam_group': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'instructor': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'limit': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'time': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '100', 'null': 'True'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'units': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '20', 'null': 'True'}),
            'waitlist': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '10', 'null': 'True'})
        },
        'data.timespan': {
            'Meta': {'object_name': 'TimeSpan'},
            'days': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'span': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'type': ('django.db.models.fields.CharField', [], {'max_length': '50'})
        },
        'data.webcast': {
            'Meta': {'object_name': 'Webcast'},
            'description': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'number': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'title': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '200', 'null': 'True'}),
            'url': ('django.db.models.fields.CharField', [], {'default': "''", 'max_length': '1000', 'null': 'True'})
        }
    }

    complete_apps = ['data']
