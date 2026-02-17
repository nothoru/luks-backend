# feedback/urls.py
from django.urls import path
from .views import FeedbackCreateView, AdminFeedbackListView, FeedbackStatsView

urlpatterns = [
    path('submit/', FeedbackCreateView.as_view(), name='feedback-submit'),
    path('admin/all/', AdminFeedbackListView.as_view(), name='admin-feedback-list'),
    path('admin/stats/', FeedbackStatsView.as_view(), name='admin-feedback-stats'),
]