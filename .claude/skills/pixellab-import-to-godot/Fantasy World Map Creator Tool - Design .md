Fantasy World Map Creator Tool - Design Document                                                                          
                                                                                                                            
  This would transform the current basic terrain view into a proper cartography tool for creating rich, hand-crafted fantasy
   maps like Westeros, Middle-earth, or Faerûn.                                                                             
                                                                                                                            
  ---                                                                                                                       
  Current State vs. Vision                                                                                                  
                                                                                                                            
  Current: Auto-generated terrain cells based on location proximity and region names. Simple colored squares with noise     
  variation.                                                                                                                
                                                                                                                            
  Vision: A multi-layer painting and procedural generation system that produces publication-quality fantasy maps with       
  mountains, rivers, coastlines, forests, and political boundaries.                                                         
                                                                                                                            
  ---                                                                                                                       
  Architecture Overview                                                                                                     
                                                                                                                            
  Multi-Layer Rendering System                                                                                              
                                                                                                                            
  Layer 7: UI Overlays (compass rose, legend, scale bar)                                                                    
  Layer 6: Labels & Names (location names, region names, sea names)                                                         
  Layer 5: Locations (cities, towns, dungeons - existing system)                                                            
  Layer 4: Routes & Roads (existing routes rendered as proper roads)                                                        
  Layer 3: Political Borders (kingdom boundaries, regional divisions)                                                       
  Layer 2: Features (mountain ranges, rivers, forest boundaries)                                                            
  Layer 1: Biomes (terrain types painted on grid)                                                                           
  Layer 0: Landmass (coastlines defining land vs. water)                                                                    
                                                                                                                            
  Each layer has independent visibility, opacity, and editability.                                                          
                                                                                                                            
  ---                                                                                                                       
  Core Systems                                                                                                              
                                                                                                                            
  1. Landmass Editor (Coastlines & Continents)                                                                              
                                                                                                                            
  Purpose: Define the fundamental shape of continents, islands, and water bodies.                                           
                                                                                                                            
  Tools:                                                                                                                    
  - Coastline Brush: Paint land/water boundary                                                                              
  - Island Stamp: Place pre-made island shapes                                                                              
  - Continent Generator: Procedural landmass from noise + tectonics                                                         
  - Coastal Detail Tool: Add bays, peninsulas, fjords, archipelagos                                                         
  - Sea Fill: Auto-identify enclosed water bodies as seas/lakes                                                             
                                                                                                                            
  Data Structure:                                                                                                           
  var landmass_mask: Image  # Binary mask: land vs water                                                                    
  var coastline_paths: Array[PackedVector2Array]  # Vector coastlines for smooth rendering                                  
  var water_bodies: Array[WaterBody]  # Named seas, lakes, bays                                                             
                                                                                                                            
  Rendering: Coastlines get special treatment with:                                                                         
  - Subtle wave patterns along edges                                                                                        
  - Coastal shading (lighter near shore)                                                                                    
  - Optional "worn edge" effect for parchment style                                                                         
                                                                                                                            
  ---                                                                                                                       
  2. Terrain/Biome Painter                                                                                                  
                                                                                                                            
  Purpose: Paint the fundamental terrain types across the landmass.                                                         
                                                                                                                            
  Terrain Types:                                                                                                            
  ┌──────────────┬──────────────────┬─────────────────────────────────────┐                                                 
  │     Type     │      Visual      │             Description             │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Plains       │ Light green      │ Open grasslands                     │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Forest       │ Dark green       │ Wooded areas (density varies)       │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Dense Forest │ Darker green     │ Thick, old-growth woods             │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Hills        │ Tan/brown        │ Rolling elevated terrain            │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Mountains    │ Gray/white peaks │ High elevation (see Feature system) │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Desert       │ Sandy tan        │ Arid regions                        │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Swamp        │ Murky green      │ Wetlands, marshes                   │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Tundra       │ White/pale blue  │ Frozen plains                       │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Wasteland    │ Dead brown       │ Corrupted/dead lands                │                                                 
  ├──────────────┼──────────────────┼─────────────────────────────────────┤                                                 
  │ Farmland     │ Patchwork green  │ Cultivated regions near settlements │                                                 
  └──────────────┴──────────────────┴─────────────────────────────────────┘                                                 
  Tools:                                                                                                                    
  - Biome Brush: Paint terrain with adjustable size/hardness                                                                
  - Elevation Brush: Raise/lower terrain (affects biome transitions)                                                        
  - Blend Tool: Smooth transitions between biomes                                                                           
  - Fill Region: Flood-fill enclosed areas                                                                                  
  - Climate Generator: Auto-assign biomes based on latitude + elevation + moisture                                          
                                                                                                                            
  Procedural Options:                                                                                                       
  - Generate from noise with user-defined weights                                                                           
  - Import heightmap image                                                                                                  
  - "Simulate climate" based on mountain placement + latitude                                                               
                                                                                                                            
  ---                                                                                                                       
  3. Geographic Feature System                                                                                              
                                                                                                                            
  Purpose: Place distinct geographic features as vector objects (not grid cells) for high-quality rendering at any zoom     
  level.                                                                                                                    
                                                                                                                            
  Mountain Ranges                                                                                                           
                                                                                                                            
  Creation Methods:                                                                                                         
  - Draw Range Spine: Bezier curve tool to define the centerline                                                            
  - Peak Placement: Click to add named peaks along range                                                                    
  - Range Generator: Procedural with parameters:                                                                            
    - Length, curvature, peak density                                                                                       
    - Height variation, snow line                                                                                           
    - Foothills extent                                                                                                      
                                                                                                                            
  Properties:                                                                                                               
  class MountainRange:                                                                                                      
      var spine_path: Curve2D  # Central ridge line                                                                         
      var peaks: Array[MountainPeak]  # Named peaks with heights                                                            
      var width: float  # How wide the range appears                                                                        
      var height_profile: Curve  # Height along the spine                                                                   
      var foothills_extent: float  # How far hills extend                                                                   
      var snow_line: float  # Elevation where snow appears                                                                  
      var style: String  # "tolkien", "realistic", "iconic"                                                                 
                                                                                                                            
  Rendering Styles:                                                                                                         
  - Tolkien-style: Hand-drawn peaks with shading, iconic look                                                               
  - Relief-style: Shaded relief showing 3D form                                                                             
  - Iconic: Simple triangle symbols                                                                                         
  - Realistic: Satellite-style coloring                                                                                     
                                                                                                                            
  Rivers                                                                                                                    
                                                                                                                            
  Creation Methods:                                                                                                         
  - Draw River: Spline tool from source to mouth                                                                            
  - Auto-Generate: Rivers flow from mountains to sea following elevation                                                    
  - Add Tributary: Branch rivers that merge                                                                                 
                                                                                                                            
  Properties:                                                                                                               
  class River:                                                                                                              
      var path: Curve2D  # River course                                                                                     
      var source: Vector2  # Origin point (mountains, lake, spring)                                                         
      var mouth: Vector2  # End point (sea, lake, another river)                                                            
      var tributaries: Array[River]  # Branches that feed this river                                                        
      var width_curve: Curve  # Width along length (narrow at source, wide at mouth)                                        
      var name: String                                                                                                      
      var navigable: bool  # Can ships travel it?                                                                           
                                                                                                                            
  Rendering:                                                                                                                
  - Variable width from source to mouth                                                                                     
  - Smooth curves using Catmull-Rom or Bezier                                                                               
  - Optional "branching delta" at river mouths                                                                              
  - Lakes/ponds where rivers pool                                                                                           
                                                                                                                            
  Forests (Polygon Regions)                                                                                                 
                                                                                                                            
  Creation Methods:                                                                                                         
  - Draw Forest Boundary: Lasso tool to define forest extent                                                                
  - Forest Brush: Paint forest coverage                                                                                     
  - Auto-Forest: Fill based on moisture/elevation rules                                                                     
                                                                                                                            
  Properties:                                                                                                               
  class ForestRegion:                                                                                                       
      var boundary: PackedVector2Array  # Polygon outline                                                                   
      var density: float  # 0.0 sparse to 1.0 dense                                                                         
      var tree_type: String  # "deciduous", "conifer", "tropical", "dead"                                                   
      var name: String  # "The Whispering Woods"                                                                            
                                                                                                                            
  Rendering Options:                                                                                                        
  - Tree symbols scattered within boundary                                                                                  
  - Solid color with texture                                                                                                
  - Hand-drawn tree clusters (Tolkien-style)                                                                                
                                                                                                                            
  Other Features                                                                                                            
                                                                                                                            
  - Lakes: Enclosed water bodies with names                                                                                 
  - Swamps/Marshes: Regions with special symbols                                                                            
  - Deserts: Dune patterns, oases                                                                                           
  - Volcanoes: Special mountain with smoke/lava indicators                                                                  
  - Chasms/Canyons: Linear features cutting through terrain                                                                 
  - Islands: Small landmasses in water                                                                                      
  - Ice/Glaciers: Frozen regions with special rendering                                                                     
                                                                                                                            
  ---                                                                                                                       
  4. Political Layer                                                                                                        
                                                                                                                            
  Purpose: Define kingdoms, territories, and contested regions.                                                             
                                                                                                                            
  Features:                                                                                                                 
  - Region Boundaries: Draw borders between political entities                                                              
  - Territory Fill: Assign regions to factions with colors                                                                  
  - Contested Zones: Striped/hashed areas showing disputed territory                                                        
  - Capital Markers: Special indicators for seat of power                                                                   
  - Heraldry Integration: Display faction symbols on territories                                                            
                                                                                                                            
  Data:                                                                                                                     
  class PoliticalRegion:                                                                                                    
      var boundary: PackedVector2Array                                                                                      
      var faction_id: String  # Links to campaign factions                                                                  
      var fill_color: Color                                                                                                 
      var border_style: String  # "solid", "dashed", "disputed"                                                             
      var capital_location_id: String  # Links to a location                                                                
                                                                                                                            
  ---                                                                                                                       
  5. Route Visualization                                                                                                    
                                                                                                                            
  Purpose: Transform existing route data into visible roads/paths.                                                          
                                                                                                                            
  Route Types & Rendering:                                                                                                  
  ┌────────────────┬───────────────────────────────────┐                                                                    
  │      Type      │              Visual               │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ Highway        │ Thick brown line, double-bordered │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ Road           │ Medium brown line                 │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ Path           │ Thin dashed line                  │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ Wilderness     │ Dotted green line                 │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ Mountain Pass  │ Line through mountain with gap    │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ River Crossing │ Bridge symbol                     │                                                                    
  ├────────────────┼───────────────────────────────────┤                                                                    
  │ Sea Route      │ Dashed blue line on water         │                                                                    
  └────────────────┴───────────────────────────────────┘                                                                    
  Enhancements:                                                                                                             
  - Curved roads following terrain                                                                                          
  - Bridge/ford indicators at river crossings                                                                               
  - Pass indicators through mountains                                                                                       
  - Distance markers along routes                                                                                           
                                                                                                                            
  ---                                                                                                                       
  6. Map Decoration & Cartography                                                                                           
                                                                                                                            
  Compass Rose:                                                                                                             
  - Multiple styles (simple, ornate, medieval)                                                                              
  - Draggable placement                                                                                                     
  - Rotation to match map orientation                                                                                       
                                                                                                                            
  Scale Bar:                                                                                                                
  - "50 leagues" / "100 miles" style indicators                                                                             
  - Auto-calculate from map scale setting                                                                                   
                                                                                                                            
  Title Cartouche:                                                                                                          
  - Decorative frame for map title                                                                                          
  - Styles: scroll, banner, ornate frame                                                                                    
  - Custom text: "The Realm of Silvermere" etc.                                                                             
                                                                                                                            
  Map Border:                                                                                                               
  - Simple line, double line, ornate frame                                                                                  
  - Corner decorations                                                                                                      
  - Aged/weathered edges for parchment style                                                                                
                                                                                                                            
  Legend:                                                                                                                   
  - Auto-generated from terrain types used                                                                                  
  - Symbol key for locations                                                                                                
  - Customizable placement                                                                                                  
                                                                                                                            
  Sea Decorations:                                                                                                          
  - "Here be dragons" style monsters                                                                                        
  - Ship illustrations                                                                                                      
  - Wave patterns in open water                                                                                             
  - Named seas with decorative text                                                                                         
                                                                                                                            
  ---                                                                                                                       
  7. Visual Style Presets                                                                                                   
                                                                                                                            
  Tolkien/Hand-Drawn                                                                                                        
                                                                                                                            
  - Mountain symbols as individual peaks with shading                                                                       
  - Forest shown as clustered tree symbols                                                                                  
  - Calligraphic labels                                                                                                     
  - Minimal color, mostly line work                                                                                         
  - Parchment background                                                                                                    
                                                                                                                            
  Forgotten Realms/Colorful Fantasy                                                                                         
                                                                                                                            
  - Rich, saturated terrain colors                                                                                          
  - Detailed shading on mountains                                                                                           
  - Lush forest representation                                                                                              
  - Ornate borders and cartouches                                                                                           
  - Full color palette                                                                                                      
                                                                                                                            
  Game of Thrones/Political                                                                                                 
                                                                                                                            
  - Muted, weathered parchment                                                                                              
  - Emphasis on political boundaries                                                                                        
  - Subtle terrain                                                                                                          
  - House sigils on territories                                                                                             
  - Worn, aged appearance                                                                                                   
                                                                                                                            
  Historical Atlas                                                                                                          
                                                                                                                            
  - Sepia tones                                                                                                             
  - Simple iconography                                                                                                      
  - Clean typography                                                                                                        
  - Minimal decoration                                                                                                      
  - Educational/reference style                                                                                             
                                                                                                                            
  Satellite/Modern                                                                                                          
                                                                                                                            
  - Realistic terrain colors                                                                                                
  - Shaded relief mountains                                                                                                 
  - Natural coastlines                                                                                                      
  - No decorative elements                                                                                                  
  - Game-ready tilemap style                                                                                                
                                                                                                                            
  ---                                                                                                                       
  8. Procedural Generation Suite                                                                                            
                                                                                                                            
  Continent Generator:                                                                                                      
  Parameters:                                                                                                               
  - Seed: Random seed for reproducibility                                                                                   
  - Size: Small island to massive continent                                                                                 
  - Coastline Complexity: Smooth to highly detailed                                                                         
  - Island Chains: Number of nearby islands                                                                                 
  - Tectonic Style: Realistic plates vs. fantasy shapes                                                                     
                                                                                                                            
  Mountain Range Generator:                                                                                                 
  Parameters:                                                                                                               
  - Start/End Points: Define range extent                                                                                   
  - Curvature: Straight to winding                                                                                          
  - Peak Frequency: Dense to sparse                                                                                         
  - Height Variation: Uniform to dramatic                                                                                   
  - Foothills: None to extensive                                                                                            
                                                                                                                            
  River System Generator:                                                                                                   
  Parameters:                                                                                                               
  - Water Sources: From mountains or springs                                                                                
  - Branching Factor: Simple to complex tributaries                                                                         
  - Meandering: Straight to winding                                                                                         
  - Delta Formation: At coastlines                                                                                          
                                                                                                                            
  Climate Simulation:                                                                                                       
  Inputs:                                                                                                                   
  - Mountain placement (rain shadows)                                                                                       
  - Latitude (temperature gradient)                                                                                         
  - Ocean currents (moisture)                                                                                               
                                                                                                                            
  Outputs:                                                                                                                  
  - Auto-assigned biomes                                                                                                    
  - Forest density                                                                                                          
  - Desert/tundra placement                                                                                                 
                                                                                                                            
  ---                                                                                                                       
  9. Editor UI Layout                                                                                                       
                                                                                                                            
  ┌─────────────────────────────────────────────────────────────┐                                                           
  │ [Tools] [Generate] [Style] [Export]          [Layers Panel] │                                                           
  ├─────────────────────────────────────────────────────────────┤                                                           
  │                                              │ □ Decorations │                                                          
  │                                              │ □ Labels      │                                                          
  │                                              │ □ Locations   │                                                          
  │         MAIN CANVAS                          │ □ Routes      │                                                          
  │         (Pan/Zoom/Paint)                     │ □ Political   │                                                          
  │                                              │ □ Features    │                                                          
  │                                              │ □ Biomes      │                                                          
  │                                              │ □ Landmass    │                                                          
  ├─────────────────────────────────────────────────────────────┤                                                           
  │ [Brush] [Select] [Spline] [Fill]  │ Brush Size: ═══○═══     │                                                           
  │                                    │ Hardness: ═══○═══      │                                                           
  │ Active: Mountain Range Tool        │ Opacity: ═══○═══       │                                                           
  └─────────────────────────────────────────────────────────────┘                                                           
                                                                                                                            
  Tool Categories:                                                                                                          
  - Selection: Select features, move, delete                                                                                
  - Brush: Paint terrain, coastlines                                                                                        
  - Spline: Draw rivers, mountain ranges, roads                                                                             
  - Polygon: Define regions, forests                                                                                        
  - Stamp: Place pre-made features                                                                                          
  - Text: Add labels and names                                                                                              
                                                                                                                            
  ---                                                                                                                       
  10. Data Persistence                                                                                                      
                                                                                                                            
  Extended WorldMap JSON:                                                                                                   
  {                                                                                                                         
    "geography": {                                                                                                          
      "landmass_image": "base64_or_path",                                                                                   
      "coastlines": [...vector paths...],                                                                                   
      "biome_grid": {...},                                                                                                  
      "mountain_ranges": [                                                                                                  
        {                                                                                                                   
          "id": "iron_mountains",                                                                                           
          "name": "The Iron Mountains",                                                                                     
          "spine": [[100,50], [200,80], [350,60]],                                                                          
          "peaks": [                                                                                                        
            {"name": "Mount Dread", "position": [150,65], "height": 0.9}                                                    
          ]                                                                                                                 
        }                                                                                                                   
      ],                                                                                                                    
      "rivers": [...],                                                                                                      
      "forests": [...],                                                                                                     
      "water_bodies": [...]                                                                                                 
    },                                                                                                                      
    "political": {                                                                                                          
      "regions": [...],                                                                                                     
      "borders": [...]                                                                                                      
    },                                                                                                                      
    "cartography": {                                                                                                        
      "style": "tolkien",                                                                                                   
      "compass_rose": {"position": [50, 50], "style": "ornate"},                                                            
      "title": {"text": "The Shattered Kingdoms", "position": [400, 30]},                                                   
      "scale": {"miles_per_pixel": 0.5}                                                                                     
    },                                                                                                                      
    "locations": [...existing...],                                                                                          
    "routes": [...existing...],                                                                                             
    "regions": [...existing...]                                                                                             
  }                                                                                                                         
                                                                                                                            
  ---                                                                                                                       
  Implementation Phases                                                                                                     
                                                                                                                            
  Phase 1: Basic terrain painting (brush-based biome editing)                                                               
  Phase 2: Mountain range and river feature system                                                                          
  Phase 3: Political boundaries and route rendering                                                                         
  Phase 4: Visual style presets and cartographic decorations                                                                
  Phase 5: Procedural generation tools                                                                                      
  Phase 6: Export to tilemap/image formats                                                                                  
                                                                                                                            
  ---                                                                                                                       
  This would give you a proper fantasy cartography tool integrated into the World Map Builder, capable of creating maps with
   the richness of professionally published fantasy atlases.                                                                
                                                                   