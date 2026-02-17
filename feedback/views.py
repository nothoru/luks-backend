# feedback/views.py
from rest_framework import generics
from rest_framework.views import APIView 
from rest_framework.response import Response 
from rest_framework.permissions import IsAuthenticated
from .models import Feedback
from .serializers import FeedbackCreateSerializer, FeedbackListSerializer
from users.permissions import IsAdminUser 
from .utils import analyze_sentiment
from backend.pagination import StandardResultsSetPagination
from django.db.models import Count 



class FeedbackCreateView(generics.CreateAPIView):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackCreateSerializer
    permission_classes = [IsAuthenticated] 

    def perform_create(self, serializer):
        comment_text = serializer.validated_data.get('comment', '')

        sentiment_label, sentiment_score = analyze_sentiment(comment_text)

        serializer.save(
            user=self.request.user,
            sentiment_label=sentiment_label,
            sentiment_score=sentiment_score
        )

class AdminFeedbackListView(generics.ListAPIView):
    queryset = Feedback.objects.all()
    serializer_class = FeedbackListSerializer
    permission_classes = [IsAuthenticated, IsAdminUser] 

    pagination_class = StandardResultsSetPagination

class FeedbackStatsView(APIView):
    permission_classes = [IsAuthenticated, IsAdminUser]

    def get(self, request):
        stats = Feedback.objects.values('sentiment_label').annotate(count=Count('id'))
        
        data = {item['sentiment_label']: item['count'] for item in stats}
        
        total = Feedback.objects.count()
        
        response_data = {
            'total': total,
            'positive': data.get('positive', 0),
            'neutral': data.get('neutral', 0),
            'negative': data.get('negative', 0),
        }
        
        return Response(response_data)
