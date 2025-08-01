# menu/serializers.py
from rest_framework import serializers
from .models import MenuItems, Variations, Categories

class VariationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Variations
        fields = ['id', 'size_name', 'price', 'stock_level', 'is_available']
        read_only_fields = ['id']

class CategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = Categories
        fields = ['id', 'name']

class MenuItemSerializer(serializers.ModelSerializer):
    variations = VariationSerializer(many=True, read_only=True)
    category = CategorySerializer(read_only=True)
    is_fully_out_of_stock = serializers.BooleanField(read_only=True)
    
    
    category_id = serializers.IntegerField(write_only=True)

    image = serializers.SerializerMethodField()


    class Meta:
        model = MenuItems
        fields = [
            'id', 'name', 'image', 'is_available',
            'category', 'category_id', 
            'variations', 
            'is_fully_out_of_stock' 
        ]
        
    def get_image(self, obj):
        request = self.context.get('request')
        if obj.image and hasattr(obj.image, 'url'):
            # This will correctly build the full URL, e.g., https://.../media/image.jpg
            return request.build_absolute_uri(obj.image.url)
        return None # Return null if there is no image     