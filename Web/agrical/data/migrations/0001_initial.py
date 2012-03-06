# encoding: utf-8
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models

class Migration(SchemaMigration):

    def forwards(self, orm):
        
        # Adding model 'BusVehicle'
        db.create_table('data_busvehicle', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('vehicle_id', self.gf('django.db.models.fields.IntegerField')()),
            ('route_tag', self.gf('django.db.models.fields.CharField')(max_length=10)),
            ('dir_tag', self.gf('django.db.models.fields.CharField')(max_length=10, null=True)),
            ('latitude', self.gf('django.db.models.fields.FloatField')()),
            ('longitude', self.gf('django.db.models.fields.FloatField')()),
            ('seconds_since_report', self.gf('django.db.models.fields.IntegerField')()),
            ('predictable', self.gf('django.db.models.fields.BooleanField')(default=False)),
            ('heading', self.gf('django.db.models.fields.FloatField')()),
            ('speed', self.gf('django.db.models.fields.FloatField')()),
        ))
        db.send_create_signal('data', ['BusVehicle'])

        # Adding model 'BusLine'
        db.create_table('data_busline', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('line_title', self.gf('django.db.models.fields.CharField')(max_length=50)),
            ('line_tag', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('data', ['BusLine'])

        # Adding M2M table for field vehicles on 'BusLine'
        db.create_table('data_busline_vehicles', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('busline', models.ForeignKey(orm['data.busline'], null=False)),
            ('busvehicle', models.ForeignKey(orm['data.busvehicle'], null=False))
        ))
        db.create_unique('data_busline_vehicles', ['busline_id', 'busvehicle_id'])

        # Adding model 'MenuItem'
        db.create_table('data_menuitem', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('name', self.gf('django.db.models.fields.CharField')(max_length=200)),
            ('type', self.gf('django.db.models.fields.CharField')(default='Normal', max_length=50)),
        ))
        db.send_create_signal('data', ['MenuItem'])

        # Adding model 'Menu'
        db.create_table('data_menu', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('location', self.gf('django.db.models.fields.CharField')(max_length=50)),
        ))
        db.send_create_signal('data', ['Menu'])

        # Adding M2M table for field breakfast on 'Menu'
        db.create_table('data_menu_breakfast', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['data.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['data.menuitem'], null=False))
        ))
        db.create_unique('data_menu_breakfast', ['menu_id', 'menuitem_id'])

        # Adding M2M table for field lunch on 'Menu'
        db.create_table('data_menu_lunch', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['data.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['data.menuitem'], null=False))
        ))
        db.create_unique('data_menu_lunch', ['menu_id', 'menuitem_id'])

        # Adding M2M table for field brunch on 'Menu'
        db.create_table('data_menu_brunch', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['data.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['data.menuitem'], null=False))
        ))
        db.create_unique('data_menu_brunch', ['menu_id', 'menuitem_id'])

        # Adding M2M table for field dinner on 'Menu'
        db.create_table('data_menu_dinner', (
            ('id', models.AutoField(verbose_name='ID', primary_key=True, auto_created=True)),
            ('menu', models.ForeignKey(orm['data.menu'], null=False)),
            ('menuitem', models.ForeignKey(orm['data.menuitem'], null=False))
        ))
        db.create_unique('data_menu_dinner', ['menu_id', 'menuitem_id'])


    def backwards(self, orm):
        
        # Deleting model 'BusVehicle'
        db.delete_table('data_busvehicle')

        # Deleting model 'BusLine'
        db.delete_table('data_busline')

        # Removing M2M table for field vehicles on 'BusLine'
        db.delete_table('data_busline_vehicles')

        # Deleting model 'MenuItem'
        db.delete_table('data_menuitem')

        # Deleting model 'Menu'
        db.delete_table('data_menu')

        # Removing M2M table for field breakfast on 'Menu'
        db.delete_table('data_menu_breakfast')

        # Removing M2M table for field lunch on 'Menu'
        db.delete_table('data_menu_lunch')

        # Removing M2M table for field brunch on 'Menu'
        db.delete_table('data_menu_brunch')

        # Removing M2M table for field dinner on 'Menu'
        db.delete_table('data_menu_dinner')


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
        'data.menu': {
            'Meta': {'object_name': 'Menu'},
            'breakfast': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'breakfast'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'brunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'brunch'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'dinner': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'dinner'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'location': ('django.db.models.fields.CharField', [], {'max_length': '50'}),
            'lunch': ('django.db.models.fields.related.ManyToManyField', [], {'related_name': "'lunch'", 'symmetrical': 'False', 'to': "orm['data.MenuItem']"})
        },
        'data.menuitem': {
            'Meta': {'object_name': 'MenuItem'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'name': ('django.db.models.fields.CharField', [], {'max_length': '200'}),
            'type': ('django.db.models.fields.CharField', [], {'default': "'Normal'", 'max_length': '50'})
        }
    }

    complete_apps = ['data']
