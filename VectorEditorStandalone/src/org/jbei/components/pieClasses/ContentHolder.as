package org.jbei.components.pieClasses
{
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.display.Graphics;
    import flash.events.ContextMenuEvent;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    import flash.ui.ContextMenu;
    import flash.ui.ContextMenuItem;
    import flash.ui.Keyboard;
    import flash.utils.Dictionary;
    
    import mx.controls.Alert;
    import mx.core.EdgeMetrics;
    import mx.core.UIComponent;
    
    import org.jbei.bio.data.CutSite;
    import org.jbei.bio.data.DNASequence;
    import org.jbei.bio.data.Feature;
    import org.jbei.bio.data.IAnnotation;
    import org.jbei.bio.data.ORF;
    import org.jbei.bio.utils.SequenceUtils;
    import org.jbei.components.Pie;
    import org.jbei.components.common.Alignment;
    import org.jbei.components.common.CaretEvent;
    import org.jbei.components.common.SelectionEvent;
    import org.jbei.lib.FeaturedSequence;
    import org.jbei.lib.ORFMapper;
    import org.jbei.lib.RestrictionEnzymeMapper;
	
	public class ContentHolder extends UIComponent
	{
		private const BACKGROUND_COLOR:int = 0xFFFFFF;
		private const CONNECTOR_LINE_COLOR:int = 0x000000;
		private const CONNECTOR_LINE_TRASPARENCY:Number = 0.2;
		private const RAIL_HEIGHT:uint = 5;
		private const PIE_RADIUS_PERCENTS:Number = 0.60;
		private const SELECTION_THRESHOLD:Number = 5;
		
		private var pie:Pie;
		private var rail:Rail;
		private var selectionLayer:SelectionLayer;
		private var caret:Caret;
		
		private var customContextMenu:ContextMenu;
		private var editFeatureContextMenuItem:ContextMenuItem;
		private var selectedAsNewFeatureContextMenuItem:ContextMenuItem;
		
		private var _featuredSequence:FeaturedSequence;
		private var _orfMapper:ORFMapper;
		private var _restrictionEnzymeMapper:RestrictionEnzymeMapper;
		
		private var railRadius:Number = 0;
		private var _center:Point = new Point(0, 0);
		private var _caretPosition:int;
		private var parentWidth:Number = 0;
		private var parentHeight:Number = 0;
		private var shiftKeyDown:Boolean = false;
		private var shiftDownCaretPosition:int = -1;
		private var featureRenderers:Array = new Array(); /* of FeatureRenderer */
		private var cutSiteRenderers:Array = new Array(); /* of CutSiteRenderer */
		private var orfRenderers:Array = new Array(); /* of ORFRenderer */
		private var labelBoxes:Array /* of LabelBox */  = new Array();
		private var leftTopLabels:Array /* of LabelBox */ = new Array();
		private var leftBottomLabels:Array /* of LabelBox */ = new Array();
		private var rightTopLabels:Array /* of LabelBox */ = new Array();
		private var rightBottomLabels:Array /* of LabelBox */ = new Array();
		private var featuresToRendererMap:Dictionary = new Dictionary(); /* [Feature] = FeatureRenderer  */
		private var cutSitesToRendererMap:Dictionary = new Dictionary(); /* [CutSite] = CutSiteRenderer  */
		private var _totalHeight:int = 0;
		private var _totalWidth:int = 0;
		private var _showFeatures:Boolean = true;
		private var _showCutSites:Boolean = true;
		private var _showFeatureLabels:Boolean = true;
		private var _showCutSiteLabels:Boolean = true;
		private var _showORFs:Boolean = true;
		
		private var mouseIsDown:Boolean = false;
		private var clickPoint:Point;
		private var mouseOverSelection:Boolean = false;
		private var invalidSequence:Boolean = true;
		private var startSelectionIndex:int;
		private var endSelectionIndex:int;
		
		private var featuredSequenceChanged:Boolean = false;
		private var orfMapperChanged:Boolean = false;
		private var restrictionEnzymeMapperChanged:Boolean = false;
		private var featuresAlignmentChanged:Boolean = false;
		private var orfsAlignmentChanged:Boolean = false;
		private var needsMeasurement:Boolean = false;
		private var richSequenceChanged:Boolean = false;
		private var showFeaturesChanged:Boolean = false;
		private var showCutSitesChanged:Boolean = false;
		private var showFeatureLabelsChanged:Boolean = false;
		private var showCutSiteLabelsChanged:Boolean = false;
		private var showORFsChanged:Boolean = false;
		
		private var featureAlignmentMap:Dictionary;
		private var orfAlignmentMap:Dictionary;
		
		// Contructor
		public function ContentHolder(pie:Pie)
		{
			super();
			
			this.pie = pie;
			
			doubleClickEnabled = true;
		}
		
		// Properties
		public function get featuredSequence():FeaturedSequence
		{
			return _featuredSequence;
		}
		
		public function set featuredSequence(value:FeaturedSequence):void
		{
			_featuredSequence = value;
			
			invalidateProperties();
			
			featuredSequenceChanged = true;
		}
		
		public function get restrictionEnzymeMapper():RestrictionEnzymeMapper
		{
			return _restrictionEnzymeMapper;
		}
		
		public function set restrictionEnzymeMapper(value:RestrictionEnzymeMapper):void
		{
			_restrictionEnzymeMapper = value;
			
			invalidateProperties();
			
			restrictionEnzymeMapperChanged = true;
		}
		
		public function get orfMapper():ORFMapper
		{
			return _orfMapper;
		}
		
		public function set orfMapper(value:ORFMapper):void
		{
			_orfMapper = value;
			
			invalidateProperties();
			
			orfMapperChanged = true;
		}
		
		public function get showFeatures():Boolean
		{
			return _showFeatures;
		}
		
		public function set showFeatures(value:Boolean):void
		{
			if(_showFeatures != value) {
				_showFeatures = value;
				
				invalidateProperties();
				
				showFeaturesChanged = true;
			}
		}
		
		public function get showCutSites():Boolean
		{
			return _showCutSites;
		}
		
		public function set showCutSites(value:Boolean):void
		{
			if(_showCutSites != value) {
				_showCutSites = value;
				
				invalidateProperties();
				
				showCutSitesChanged = true;
			}
		}

		public function get showFeatureLabels():Boolean
		{
			return _showFeatureLabels;
		}
		
		public function set showFeatureLabels(value:Boolean):void
		{
			if(_showFeatureLabels != value) {
				_showFeatureLabels = value;
				
				invalidateProperties();
				
				showFeatureLabelsChanged = true;
			}
		}
		
		public function get showCutSiteLabels():Boolean
		{
			return _showCutSiteLabels;
		}
		
		public function set showCutSiteLabels(value:Boolean):void
		{
			if(_showCutSiteLabels != value) {
				_showCutSiteLabels = value;
				
				invalidateProperties();
				
				showCutSiteLabelsChanged = true;
			}
		}
		
		public function get showORFs():Boolean
		{
			return _showORFs;
		}
		
		public function set showORFs(value:Boolean):void
		{
			if(_showORFs != value) {
				_showORFs = value;
				
				invalidateProperties();
				
				showORFsChanged = true;
			}
		}
		
		public function get caretPosition():int
		{
			return _caretPosition;
		}
		
		public function set caretPosition(value:int):void
		{
			if(_caretPosition != value) {
				tryMoveCaretToPosition(value);
			}
		}
		
		public function get center():Point
		{
			return _center;
		}
		
		public function get totalHeight():Number
		{
			return _totalHeight;
		}
		
		public function get totalWidth():Number
		{
			return _totalWidth;
		}
		
	    public function get selectionStart():int
	    {
	    	return startSelectionIndex;
	    }
	    
	    public function get selectionEnd():int
	    {
	    	return endSelectionIndex;
	    }
	    
		// Public Methods
		public function updateMetrics(parentWidth:Number, parentHeight:Number):void
		{
			this.parentWidth = parentWidth;
			this.parentHeight = parentHeight;
			
        	_center = new Point(parentWidth / 2, parentHeight / 2);
        	railRadius = PIE_RADIUS_PERCENTS * Math.min(parentWidth / 2, parentHeight / 2);
			
			needsMeasurement = true;
			
			invalidateDisplayList();
		}
		
		public function select(startIndex: int, endIndex: int):void
		{
			if(invalidSequence) { return; }
			
			if(!isValidIndex(startIndex) || !isValidIndex(endIndex)) {
				deselect();
			} else if(selectionLayer.start != startIndex || selectionLayer.end != endIndex) {
				doSelect(startIndex, endIndex);
				
				dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
			}
		}
		
		public function deselect():void
		{
			if(invalidSequence) { return; }
			
			if(selectionLayer.start != -1 || selectionLayer.end != -1) {
				doDeselect();
				
				dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
			}
		}
		
		public function showCaret():void
		{
			if(invalidSequence) { return; }
			
			caret.show();
		}
		
		public function hideCaret():void
		{
			if(invalidSequence) { return; }
			
			caret.hide();
		}
		
		public function isValidIndex(index:int):Boolean
		{
			return index >= 0 && index < featuredSequence.sequence.length;
		}
		
	    // Protected Methods
		protected override function createChildren():void
		{
			super.createChildren();
			
			createContextMenu();
			
	        createRailBox();
	        
	        createSelectionLayer();
	        
	        createCaret();
	 	}
	 	
	 	protected override function commitProperties():void
	 	{
	 		super.commitProperties();
	 		
			if(! _featuredSequence) {
				disableSequence();
				
				invalidateDisplayList();
				
				return;
			}
			
			if(featuredSequenceChanged) {
				featuredSequenceChanged = false;
				
				initializeSequence();
				
				needsMeasurement = true;
				
				invalidateDisplayList();
			}
			
			if(restrictionEnzymeMapperChanged) {
				restrictionEnzymeMapperChanged = false;
				
				needsMeasurement = true;
				
				invalidateDisplayList();
			}
			
			if(orfMapperChanged) {
				orfMapperChanged = false;
				
				needsMeasurement = true;
				orfsAlignmentChanged = true;
				
				invalidateDisplayList();
			}
			
			if(showFeaturesChanged) {
				showFeaturesChanged = false;
				
				needsMeasurement = true;
				featuresAlignmentChanged = true;
				
				invalidateDisplayList();
			}
			
			if(showCutSitesChanged) {
				showCutSitesChanged = false;
				
				needsMeasurement = true;
				
				invalidateDisplayList();
			}
			
			if(showFeatureLabelsChanged) {
				showFeatureLabelsChanged = false;
				
				needsMeasurement = true;
				
				invalidateDisplayList();
			}
			
			if(showCutSiteLabelsChanged) {
				showCutSiteLabelsChanged = false;
				
				needsMeasurement = true;
				
				invalidateDisplayList();
			}
			
	        if(showORFsChanged) {
	        	showORFsChanged = false;
	        	
	        	needsMeasurement = true;
	        	orfsAlignmentChanged = true;
	        	
	        	invalidateDisplayList();
	        }
	 	}
	 	
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
	        super.updateDisplayList(unscaledWidth, unscaledHeight);
	        
			if(invalidSequence) {
				removeLabels();
				removeFeatureRenderers();
				removeCutSiteRenderers();
				removeORFRenderers();
				
				_totalHeight = parentHeight;
				_totalWidth = parentWidth;
				
				drawBackground();
				
				doDeselect();
				caret.hide();
				
				return;
			}
			
			if(featuresAlignmentChanged) {
	        	featuresAlignmentChanged = false;
	        	
		        rebuildFeaturesAlignment();
	        }
	        
			if(orfsAlignmentChanged) {
	        	orfsAlignmentChanged = false;
	        	
		        rebuildORFsAlignment();
	        }
	        
	        if(needsMeasurement) {
	        	needsMeasurement = false;
	        	
				_totalHeight = parentHeight;
				_totalWidth = parentWidth;
				
	        	loadFeatureRenderers();
				loadCutSiteRenderers();
				loadORFRenderers();
	        	loadLabels();
		        
		        renderLabels();
		        renderFeatures();
				renderCutSites();
				renderORFs();
		        
		        // update children metrics
		        rail.updateMetrics(railRadius, _center, RAIL_HEIGHT);
		        
		        caret.updateMetrics(_center, railRadius + 10);
		        
	        	drawBackground();
		        drawConnections();
		        
		        selectionLayer.updateMetrics(railRadius + 10, _center);
	        }
		}
		
		// Private Methods
		private function disableSequence():void
		{
			featureAlignmentMap = null;
			orfAlignmentMap = null;
			
			caretPosition = 0;
			
			invalidSequence = true;
			
			removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			removeEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
			
			pie.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			pie.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			pie.removeEventListener(Event.SELECT_ALL, onSelectAll);
			pie.removeEventListener(Event.COPY, onCopy);
			pie.removeEventListener(Event.CUT, onCut);
			pie.removeEventListener(Event.PASTE, onPaste);
			
			removeEventListener(SelectionEvent.SELECTION_CHANGED, onSelectionChanged);
		}
		
		private function initializeSequence():void
		{
			invalidSequence = false;
			
			featuresAlignmentChanged = true;
			orfsAlignmentChanged = true;
			
			if(selectionLayer.selected) {
				doDeselect();
			}
			
			_caretPosition = 0;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
			
			pie.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			pie.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			pie.addEventListener(Event.SELECT_ALL, onSelectAll);
			pie.addEventListener(Event.COPY, onCopy);
			pie.addEventListener(Event.CUT, onCut);
			pie.addEventListener(Event.PASTE, onPaste);
			
			addEventListener(SelectionEvent.SELECTION_CHANGED, onSelectionChanged);
		}
		
        private function createContextMenu():void
        {
			customContextMenu = new ContextMenu();
			
			customContextMenu.hideBuiltInItems(); //hide the Flash built-in menu
			customContextMenu.clipboardMenu = true; // activate Copy, Paste, Cut, Menu items
			customContextMenu.clipboardItems.paste = true;
			customContextMenu.clipboardItems.selectAll = true;
			
			contextMenu = customContextMenu;
			
			customContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, onContextMenuSelect);
			
			createCustomContextMenuItems();
        }
        
        private function createCustomContextMenuItems():void
        {
			editFeatureContextMenuItem = new ContextMenuItem("Edit Feature");
			editFeatureContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onEditFeatureMenuItem);
        	
			selectedAsNewFeatureContextMenuItem = new ContextMenuItem("Selected as New Feature");
			selectedAsNewFeatureContextMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onSelectedAsNewFeatureMenuItem);
        }
        
	 	private function createRailBox():void
	 	{
	        if(!rail) {
	            rail = new Rail(this);
	            rail.includeInLayout = false;
	            
            	addChild(rail);
	        }
	 	}
	 	
	 	private function createSelectionLayer():void
	 	{
	        if(!selectionLayer) {
	            selectionLayer = new SelectionLayer(this);
	            selectionLayer.includeInLayout = false;
            	addChild(selectionLayer);
	        }
	 	}
	 	
	 	private function createCaret():void
		{
	        if(!caret) {
	            caret = new Caret(this);
	            caret.includeInLayout = false;
            	addChild(caret);
	        }
		}
	 	
	    private function onMouseDown(event:MouseEvent):void
	    {
	    	if(event.target is AnnotationRenderer) { return; }
	    	
	    	if(selectionLayer.selected) {
	    		deselect();
	    	}
	    	
	    	mouseIsDown = true;
	    	
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			startSelectionIndex = bpAtPoint(new Point(event.stageX, event.stageY));
			
			clickPoint = new Point(event.stageX, event.stageY);
			
			tryMoveCaretToPosition(startSelectionIndex);
	    }
	    
	    private function onMouseMove(event:MouseEvent):void
	    {
	    	if((mouseIsDown && Point.distance(clickPoint, new Point(event.stageX, event.stageY)) > SELECTION_THRESHOLD)) {
	    		endSelectionIndex = bpAtPoint(new Point(event.stageX, event.stageY));
	    		
	    		selectionLayer.startSelecting();
	    		selectionLayer.select(startSelectionIndex, endSelectionIndex);
	    		
				tryMoveCaretToPosition(endSelectionIndex + 1);
	    	}
	    }
	    
		private function onMouseUp(event:MouseEvent):void
	    {
	    	if(!mouseIsDown) { return; }
	    	
	    	mouseIsDown = false;
	    	stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	    	stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
	    	
	    	if(selectionLayer.selected && selectionLayer.selecting) {
		    	selectionLayer.endSelecting();
		    	
		    	dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
	    	}
	    }
	    
        private function onMouseDoubleClick(event:MouseEvent):void
        {
        	if(event.target is FeatureRenderer) {
        		dispatchEvent(new PieEvent(PieEvent.EDIT_FEATURE, true, false, (event.target as FeatureRenderer).feature));
        	}
        }
        
        private function onContextMenuSelect(event:ContextMenuEvent):void
		{
			customContextMenu.customItems = new Array();
			
			if(event.mouseTarget is FeatureRenderer) {
		        customContextMenu.customItems.push(editFeatureContextMenuItem);
			}
			
			if(selectionLayer.selected) {
		        customContextMenu.customItems.push(selectedAsNewFeatureContextMenuItem);
			}
		}
		
		private function onEditFeatureMenuItem(event:ContextMenuEvent):void
		{
			dispatchEvent(new PieEvent(PieEvent.EDIT_FEATURE, true, true, (event.mouseTarget as FeatureRenderer).feature));
		}
		
		private function onSelectedAsNewFeatureMenuItem(event:ContextMenuEvent):void
		{
			dispatchEvent(new PieEvent(PieEvent.CREATE_FEATURE, true, true, new Feature(selectionLayer.start, selectionLayer.end)));
		}
		
	    private function onSelectAll(event:Event):void
	    {
	    	select(0, _featuredSequence.sequence.length - 1);
	    }
	    
	    private function onCopy(event:Event):void
	    {
	    	if((selectionStart >= 0) && (selectionEnd >= 0)) {
				Clipboard.generalClipboard.clear();
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _featuredSequence.subSequence(selectionStart, selectionEnd).sequence);
	    	}
	    }
	    
	    private function onCut(event:Event):void
	    {
	    	if((selectionStart >= 0) && (selectionEnd >= 0)) {
				Clipboard.generalClipboard.clear();
				Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, _featuredSequence.subSequence(selectionStart, selectionEnd).sequence);
        		
        		_featuredSequence.removeSequence(selectionStart, selectionEnd);
        		
        		deselect();
	    	}
	    }
	    
	    private function onPaste(event:Event):void
	    {
	    	if(_caretPosition >= 0 && Clipboard.generalClipboard.hasFormat(ClipboardFormats.TEXT_FORMAT)) {
	    		var pasteSequence:String = String(Clipboard.generalClipboard.getData(ClipboardFormats.TEXT_FORMAT)).toUpperCase();
	    		for(var i:int = 0; i < pasteSequence.length; i++) {
	    			if(SequenceUtils.SYMBOLS.indexOf(pasteSequence.charAt(i)) == -1) {
	    				Alert.show("Paste DNA Sequence contains invalid characters at position " + i + "!\nAllowed only these \"ATGCUYRSWKMBVDHN\"");
	    				return;
	    			}
	    		}
	    		
    			_featuredSequence.insertSequence(new DNASequence(pasteSequence), _caretPosition);
    			
				tryMoveCaretToPosition(_caretPosition + pasteSequence.length);
	    	}
	    }
	    
		private function onKeyUp(event:KeyboardEvent):void
	    {
			if(shiftKeyDown) {
				if(_caretPosition < shiftDownCaretPosition) {
					doSelect(_caretPosition, shiftDownCaretPosition - 1);
					
					dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
				} else if(_caretPosition > shiftDownCaretPosition) {
					doSelect(_caretPosition - 1, shiftDownCaretPosition);
					
					dispatchEvent(new SelectionEvent(SelectionEvent.SELECTION_CHANGED, selectionLayer.start, selectionLayer.end));
				} else {
					deselect();
				}
			}
			
	    	if(!event.shiftKey) {
	    		shiftKeyDown = false;
	    	}
	    }
	    
	    private function onKeyDown(event:KeyboardEvent):void
	    {
	    	if(! _featuredSequence) { return; }
	    	
	    	if(event.shiftKey && !shiftKeyDown) {
	    		shiftDownCaretPosition = _caretPosition;
	    		shiftKeyDown = true;
	    	}
	    	
	    	if(event.keyCode == Keyboard.LEFT) {
	    		moveCaretLeft();
	    	} else if(event.keyCode == Keyboard.RIGHT) {
	    		moveCaretRight();
	    	}
	    }
	    
        private function onSelectionChanged(event:SelectionEvent):void
        {
        	if(event.start >= 0 && event.end >= 0) {
        		customContextMenu.clipboardItems.copy = true;
        		customContextMenu.clipboardItems.cut = true;
        	} else {
        		customContextMenu.clipboardItems.copy = false;
        		customContextMenu.clipboardItems.cut = false;
        	}
        }
	    
		private function drawBackground():void
		{
			var g:Graphics = graphics;
			
			g.clear();
			g.beginFill(BACKGROUND_COLOR);
			g.drawRect(0, 0, _totalWidth, _totalHeight);
			g.endFill();
		}
		
		private function removeLabels():void
		{
			// Remove old leftTopLabels
			var numberOfLeftTopLabels:uint = leftTopLabels.length;
			if(numberOfLeftTopLabels > 0) {
				for(var i1:int = numberOfLeftTopLabels - 1; i1 >= 0; i1--) {
					removeChild(leftTopLabels[i1]);
					leftTopLabels.pop();
				}
			}
			
			// Remove old rightTopLabels
			var numberOfRightTopLabels:uint = rightTopLabels.length;
			if(numberOfRightTopLabels > 0) {
				for(var i2:int = numberOfRightTopLabels - 1; i2 >= 0; i2--) {
					removeChild(rightTopLabels[i2]);
					rightTopLabels.pop();
				}
			}
			
			// Remove old leftBottomLabels
			var numberOfLeftBottomLabels:uint = leftBottomLabels.length;
			if(numberOfLeftBottomLabels > 0) {
				for(var i3:int = numberOfLeftBottomLabels - 1; i3 >= 0; i3--) {
					removeChild(leftBottomLabels[i3]);
					leftBottomLabels.pop();
				}
			}
			
			// Remove old rightBottomLabels
			var numberOfRightBottomLabels:uint = rightBottomLabels.length;
			if(numberOfRightBottomLabels > 0) {
				for(var i4:int = numberOfRightBottomLabels - 1; i4 >= 0; i4--) {
					removeChild(rightBottomLabels[i4]);
					rightBottomLabels.pop();
				}
			}
			
			var numberOfLabels:uint = labelBoxes.length;
			if(numberOfLabels > 0) {
				for(var k:int = numberOfLabels - 1; k >= 0; k--) {
					labelBoxes.pop();
				}
			}
		}
		
		private function removeFeatureRenderers():void
		{
			if(! featureRenderers) { return; }
			
			while(featureRenderers.length > 0) {
				var removedFeature:FeatureRenderer = featureRenderers.pop() as FeatureRenderer;
				
				if(contains(removedFeature)) {
					removeChild(removedFeature);
				}
			}
		}
		
		private function removeCutSiteRenderers():void
		{
			if(! cutSiteRenderers) { return; }
			
			while(cutSiteRenderers.length > 0) {
				var removedCutSite:CutSiteRenderer = cutSiteRenderers.pop() as CutSiteRenderer;
				
				if(contains(removedCutSite)) {
					removeChild(removedCutSite);
				}
			}
		}
		
		private function removeORFRenderers():void
		{
			if(! orfRenderers) { return; }
			
			while(orfRenderers.length > 0) {
				var removedORF:ORFRenderer = orfRenderers.pop() as ORFRenderer;
				
				if(contains(removedORF)) {
					removeChild(removedORF);
				}
			}
		}
		
		private function renderLabels():void
		{
			// Apply display settings to labelBoxes
			var adjustedContentMetrics:EdgeMetrics = new EdgeMetrics();
			
			// Scale Right Top Labels
			var lastLabelYPosition:Number = _center.y - 15; // -15 to count label height
			var numberOfRightTopLabels:uint = rightTopLabels.length;
			for(var i1:int = numberOfRightTopLabels - 1; i1 >= 0; i1--) {
				var labelBox1:LabelBox = rightTopLabels[i1] as LabelBox;
				
				if(! labelBox1.includeInView) { continue; }
				
				var label1Center:int = annotationCenter(labelBox1.relatedAnnotation);
				var angle1:Number = label1Center * 2 * Math.PI / _featuredSequence.sequence.length;
				
				var xPosition1:Number = _center.x + Math.sin(angle1) * (railRadius + 20);
				var yPosition1:Number = _center.y - Math.cos(angle1) * (railRadius + 20);
				
				if(yPosition1 < lastLabelYPosition) {
					lastLabelYPosition = yPosition1 - labelBox1.totalHeight;
				} else {
					yPosition1 = lastLabelYPosition;
					
					lastLabelYPosition = yPosition1 - labelBox1.totalHeight;
				}
				
				labelBox1.x = xPosition1;
				labelBox1.y = yPosition1;
				
				// Measure outling labels
				if(_totalWidth + adjustedContentMetrics.right < xPosition1 + labelBox1.totalWidth) {
					adjustedContentMetrics.right = xPosition1 + labelBox1.totalWidth - _totalWidth;
				}
				if(adjustedContentMetrics.top > yPosition1) {
					adjustedContentMetrics.top = yPosition1;
				}
			}

			// Scale Right Bottom Labels
			lastLabelYPosition = _center.y;
			var numberOfRightBottomLabels:uint = rightBottomLabels.length;
			for(var i2:int = 0; i2 < numberOfRightBottomLabels; i2++) {
				var labelBox2:LabelBox = rightBottomLabels[i2] as LabelBox;
				
				if(! labelBox2.includeInView) { continue; }
				
				var label2Center:int = annotationCenter(labelBox2.relatedAnnotation);
				var angle2:Number = label2Center * 2 * Math.PI / _featuredSequence.sequence.length - Math.PI / 2;
				
				var xPosition2:Number = _center.x + Math.cos(angle2) * (railRadius + 20);
				var yPosition2:Number = _center.y + Math.sin(angle2) * (railRadius + 20);
				
				if(yPosition2 > lastLabelYPosition) {
					lastLabelYPosition = yPosition2 + labelBox2.totalHeight;
				} else {
					yPosition2 = lastLabelYPosition;
					
					lastLabelYPosition = yPosition2 + labelBox2.totalHeight;
				}
				
				labelBox2.x = xPosition2;
				labelBox2.y = yPosition2;
				
				// Measure outling labels
				if(_totalWidth + adjustedContentMetrics.right < xPosition2 + labelBox2.totalWidth) {
					adjustedContentMetrics.right = xPosition2 + labelBox2.totalWidth - _totalWidth;
				}
				if(_totalHeight + adjustedContentMetrics.bottom < yPosition2 + labelBox2.totalHeight) {
					adjustedContentMetrics.bottom = yPosition2 + labelBox2.totalHeight - _totalHeight;
				}
			}
			
			// Scale Left Top Labels
			lastLabelYPosition = _center.y - 15; // -15 to count label totalHeight
			var numberOfLeftTopLabels:uint = leftTopLabels.length;
			for(var i3:int = 0; i3 < numberOfLeftTopLabels; i3++) {
				var labelBox3:LabelBox = leftTopLabels[i3] as LabelBox;
				
				if(! labelBox3.includeInView) { continue; }
				
				var label3Center:int = annotationCenter(labelBox3.relatedAnnotation);
				var angle3:Number = 2 * Math.PI - label3Center * 2 * Math.PI / _featuredSequence.sequence.length;
				
				var xPosition3:Number = _center.x - Math.sin(angle3) * (railRadius + 20) - labelBox3.totalWidth;
				var yPosition3:Number = _center.y - Math.cos(angle3) * (railRadius + 20);
				
				if(yPosition3 < lastLabelYPosition) {
					lastLabelYPosition = yPosition3 - labelBox3.totalHeight;
				} else {
					yPosition3 = lastLabelYPosition;
					
					lastLabelYPosition = yPosition3 - labelBox3.totalHeight;
				}
				
				labelBox3.x = xPosition3;
				labelBox3.y = yPosition3;
				
				// Measure outling labels
				if(adjustedContentMetrics.left > xPosition3) {
					adjustedContentMetrics.left = xPosition3;
				}
				if(adjustedContentMetrics.top > yPosition3) {
					adjustedContentMetrics.top = yPosition3;
				}
			}
			
			// Scale Left Bottom Labels
			lastLabelYPosition = _center.y;
			var numberOfLeftBottomLabels:uint = leftBottomLabels.length;
			for(var i4:int = numberOfLeftBottomLabels - 1; i4 >= 0; i4--) {
				var labelBox4:LabelBox = leftBottomLabels[i4] as LabelBox;
				
				if(! labelBox4.includeInView) { continue; }
				
				var label4Center:int = annotationCenter(labelBox4.relatedAnnotation);
				var angle4:Number = label4Center * 2 * Math.PI / _featuredSequence.sequence.length - Math.PI;
				
				var xPosition4:Number = _center.x - Math.sin(angle4) * (railRadius + 20) - labelBox4.totalWidth;
				var yPosition4:Number = _center.y + Math.cos(angle4) * (railRadius + 20);
				
				if(yPosition4 > lastLabelYPosition) {
					lastLabelYPosition = yPosition4 + labelBox4.totalHeight;
				} else {
					yPosition4 = lastLabelYPosition;
					
					lastLabelYPosition = yPosition4 + labelBox4.totalHeight;
				}
				
				labelBox4.x = xPosition4;
				labelBox4.y = yPosition4;
				
				// Measure outling labels
				if(adjustedContentMetrics.left > xPosition4) {
					adjustedContentMetrics.left = xPosition4;
				}
				if(_totalHeight + adjustedContentMetrics.bottom < yPosition4 + labelBox4.totalHeight) {
					adjustedContentMetrics.bottom = yPosition4 + labelBox4.totalHeight - _totalHeight;
				}
			}
			
			// Move all labels because content metrics are going to be adjusted
			if(adjustedContentMetrics.left != 0) {
				for(var j1:int = 0; j1 < numberOfRightTopLabels; j1++) { rightTopLabels[j1].x += Math.abs(adjustedContentMetrics.left) + 10; } // +10 to look pretty
				for(var j2:int = 0; j2 < numberOfRightBottomLabels; j2++) { rightBottomLabels[j2].x += Math.abs(adjustedContentMetrics.left) + 10; } // +10 to look pretty
				for(var j3:int = 0; j3 < numberOfLeftTopLabels; j3++) { leftTopLabels[j3].x += Math.abs(adjustedContentMetrics.left) + 10; } // +10 to look pretty
				for(var j4:int = 0; j4 < numberOfLeftBottomLabels; j4++) { leftBottomLabels[j4].x += Math.abs(adjustedContentMetrics.left) + 10; } // +10 to look pretty
				
				_center.x += Math.abs(adjustedContentMetrics.left) + 10; // +10 to look pretty
			}
			
			if(adjustedContentMetrics.top != 0) {
				for(var z1:int = 0; z1 < numberOfRightTopLabels; z1++) { rightTopLabels[z1].y += Math.abs(adjustedContentMetrics.top) + 10; } // +10 to look pretty
				for(var z2:int = 0; z2 < numberOfRightBottomLabels; z2++) { rightBottomLabels[z2].y += Math.abs(adjustedContentMetrics.top) + 10; } // +10 to look pretty
				for(var z3:int = 0; z3 < numberOfLeftTopLabels; z3++) { leftTopLabels[z3].y += Math.abs(adjustedContentMetrics.top) + 10; } // +10 to look pretty
				for(var z4:int = 0; z4 < numberOfLeftBottomLabels; z4++) { leftBottomLabels[z4].y += Math.abs(adjustedContentMetrics.top) + 10; } // +10 to look pretty
				
				_center.y += Math.abs(adjustedContentMetrics.top) + 10; // +10 to look pretty
			}
			
			// Adjust content metrics
			if(adjustedContentMetrics.left != 0 || adjustedContentMetrics.right != 0) {
				_totalWidth += Math.abs(adjustedContentMetrics.left) + adjustedContentMetrics.right + 30; // + 20 because scrolls takes space also, +10 to look pretty
			}
			if(adjustedContentMetrics.top != 0 || adjustedContentMetrics.bottom != 0) {
				_totalHeight += Math.abs(adjustedContentMetrics.top) + adjustedContentMetrics.bottom + 30; // + 20 because scrolls takes space also, +10 to look pretty
			}
 		}
 		
		private function renderFeatures():void
		{
			if(! featureRenderers) { return; }
			
			for(var i:int = 0; i < featureRenderers.length; i++) {
				var featureRenderer:FeatureRenderer = featureRenderers[i] as FeatureRenderer;
				
				featureRenderer.visible = _showFeatures;
				
				if(_showFeatures) {
					featureRenderer.update(_center, railRadius, featureAlignmentMap);
				}
			}
		}
		
		private function renderCutSites():void
		{
			if(! cutSiteRenderers) { return; }
			
			for(var i:int = 0; i < cutSiteRenderers.length; i++) {
				var cutSiteRenderer:CutSiteRenderer = cutSiteRenderers[i] as CutSiteRenderer;
				
				cutSiteRenderer.visible = _showCutSites;
				
				if(_showCutSites) {
					cutSiteRenderer.update(_center, railRadius);
				}
			}
		}
		
		private function renderORFs():void
		{
			if(! orfRenderers) { return; }
			
			for(var i:int = 0; i < orfRenderers.length; i++) {
				var orfRenderer:ORFRenderer = orfRenderers[i] as ORFRenderer;
				
				orfRenderer.visible = _showORFs;
				
				if(_showORFs) {
					orfRenderer.update(_center, railRadius, orfAlignmentMap);
				}
			}
		}
		
		private function loadFeatureRenderers():void
		{
			removeFeatureRenderers();
			
			if(! _featuredSequence || ! _featuredSequence.features) { return; }
			
			for(var i:int = 0; i < featuredSequence.features.length; i++) {
				var feature:Feature = featuredSequence.features[i] as Feature;
				
				var featureRenderer:FeatureRenderer = new FeatureRenderer(this, feature);
				
				featuresToRendererMap[feature] = featureRenderer;
				
				addChild(featureRenderer);
				
				featureRenderers.push(featureRenderer);
			}
		}
		
		private function loadCutSiteRenderers():void
		{
			removeCutSiteRenderers();
			
			if(!showCutSites || !featuredSequence || !_restrictionEnzymeMapper || !_restrictionEnzymeMapper.cutSites) { return; }
			
			for(var i:int = 0; i < _restrictionEnzymeMapper.cutSites.length; i++) {
				var cutSite:CutSite = _restrictionEnzymeMapper.cutSites[i] as CutSite;
				
				var cutSiteRenderer:CutSiteRenderer = new CutSiteRenderer(this, cutSite);
				
				cutSitesToRendererMap[cutSite] = cutSiteRenderer;
				
				addChild(cutSiteRenderer);
				
				cutSiteRenderers.push(cutSiteRenderer);
			}
		}
		
		private function loadORFRenderers():void
		{
			removeORFRenderers();
			
			if(!showORFs || !featuredSequence || !_orfMapper || !_orfMapper.orfs) { return; }
			
			for(var i:int = 0; i < _orfMapper.orfs.length; i++) {
				var orf:ORF = _orfMapper.orfs[i] as ORF;
				
				var orfRenderer:ORFRenderer = new ORFRenderer(this, orf);
				
				addChild(orfRenderer);
				
				orfRenderers.push(orfRenderer);
			}
		}
		
	 	private function loadLabels():void
	 	{
	 		removeLabels();
	 		
			if(_featuredSequence.features && showFeatures && showFeatureLabels) {
				// Create new labels for annotations
				var numberOfFeatures:int = _featuredSequence.features.length;
				
				for(var i:int = 0; i < numberOfFeatures; i++) {
					var feature:Feature = _featuredSequence.features[i] as Feature;
					
					var labelBox1:FeatureLabelBox = new FeatureLabelBox(this, feature);
					
					labelBoxes.push(labelBox1);
				}
			}
			
			if(showCutSites && showCutSiteLabels && _restrictionEnzymeMapper && _restrictionEnzymeMapper.cutSites) {
				// Create new labels for restriction enzymes
				var numberOfCutSites:int = _restrictionEnzymeMapper.cutSites.length;
				
				for(var j:int = 0; j < numberOfCutSites; j++) {
					var cutSite:CutSite = _restrictionEnzymeMapper.cutSites[j] as CutSite;
					
					var labelBox2:LabelBox = new CutSiteLabelBox(this, cutSite);
					
					labelBoxes.push(labelBox2);
				}
			}
			
			labelBoxes.sort(labelBoxesSort);
			
			// Split labels into 4 groups
			var totalNumberOfLabels:uint = labelBoxes.length;
			var totalLength:uint = _featuredSequence.sequence.length;
			for(var l:int = 0; l < totalNumberOfLabels; l++) {
				var labelBox:LabelBox = labelBoxes[l] as LabelBox;
				
				var labelCenter:int = annotationCenter(labelBox.relatedAnnotation);
				if(labelCenter < totalLength / 4) {
					rightTopLabels.push(labelBox);
				} else if((labelCenter >= totalLength / 4) && (labelCenter < totalLength / 2)) {
					rightBottomLabels.push(labelBox);
				} else if((labelCenter >= totalLength / 2) && (labelCenter < 3 * totalLength / 4)) {
					leftBottomLabels.push(labelBox);
				} else {
					leftTopLabels.push(labelBox);
				}
				addChild(labelBox);
				labelBox.validateNow();
			}
	 	}
	 	
	 	private function annotationCenter(annotation:IAnnotation):int
	 	{
	 		var result:int;
	 		
			if(annotation.start > annotation.end) {
				var virtualCenter:Number = annotation.end - ((featuredSequence.sequence.length - annotation.start) + (annotation.end + 1)) / 2 + 1;
				
				result = (virtualCenter >= 0) ? int(virtualCenter) : (featuredSequence.sequence.length + int(virtualCenter) - 1);
			} else {
				result = (annotation.start + annotation.end) / 2 + 1;
			}
			
			return result;
	 	}
	 	
	 	private function labelBoxesSort(labelBox1:LabelBox, labelBox2:LabelBox):int
		{
			var labelCenter1:int = annotationCenter(labelBox1.relatedAnnotation);
			var labelCenter2:int = annotationCenter(labelBox2.relatedAnnotation);
			
		    if(labelCenter1 > labelCenter2) {
		        return 1;
		    } else if(labelCenter1 < labelCenter2) {
		        return -1;
		    } else  {
		        return 0;
		    }
		}
 		
		private function drawConnections():void
		{
			var g:Graphics = graphics;
			g.lineStyle(1, CONNECTOR_LINE_COLOR, CONNECTOR_LINE_TRASPARENCY);
			
			var numberOfRightTopLabels:uint = rightTopLabels.length;
			for(var i1:uint = 0; i1 < numberOfRightTopLabels; i1++) {
				var labelBox1:LabelBox = rightTopLabels[i1] as LabelBox;
				
				if(! labelBox1.includeInView) { continue; }
				
				var annotation1:IAnnotation = labelBox1.relatedAnnotation as IAnnotation;
				
				if(annotation1 is Feature) {
					if((annotation1 as Feature).label == "" || !showFeatures || !showFeatureLabels) { continue; }
					
					var featureRenderer1:FeatureRenderer = featuresToRendererMap[annotation1] as FeatureRenderer;
					
					g.moveTo(labelBox1.x, labelBox1.y + labelBox1.totalHeight / 2);
					g.lineTo(featureRenderer1.middlePoint.x, featureRenderer1.middlePoint.y);
				} else if(annotation1 is CutSite) {
					if((annotation1 as CutSite).label == "" || !showCutSites || !showCutSiteLabels) { continue; }
					
					var cutSiteRenderer1:CutSiteRenderer = cutSitesToRendererMap[annotation1] as CutSiteRenderer;
					
					g.moveTo(labelBox1.x, labelBox1.y + labelBox1.totalHeight / 2);
					g.lineTo(cutSiteRenderer1.middlePoint.x, cutSiteRenderer1.middlePoint.y);
				}
			}
			
			var numberOfRightBottomLabels:uint = rightBottomLabels.length;
			for(var i2:uint = 0; i2 < numberOfRightBottomLabels; i2++) {
				var labelBox2:LabelBox = rightBottomLabels[i2] as LabelBox;
				
				if(! labelBox2.includeInView) { continue; }
				
				var annotation2:IAnnotation = labelBox2.relatedAnnotation as IAnnotation;
				
				if(annotation2 is Feature) {
					if((annotation2 as Feature).label == "" || !showFeatures || !showFeatureLabels) { continue; }
					
					var featureRenderer2:FeatureRenderer = featuresToRendererMap[annotation2] as FeatureRenderer;
					
					g.moveTo(labelBox2.x, labelBox2.y + labelBox2.totalHeight / 2);
					g.lineTo(featureRenderer2.middlePoint.x, featureRenderer2.middlePoint.y);
				} else if(annotation2 is CutSite) {
					if((annotation2 as CutSite).label == "" || !showCutSites || !showCutSiteLabels) { continue; }
					
					var cutSiteRenderer2:CutSiteRenderer = cutSitesToRendererMap[annotation2] as CutSiteRenderer;
					
					g.moveTo(labelBox2.x, labelBox2.y + labelBox2.totalHeight / 2);
					g.lineTo(cutSiteRenderer2.middlePoint.x, cutSiteRenderer2.middlePoint.y);
				}
			}
			
			var numberOfLeftTopLabels:uint = leftTopLabels.length;
			for(var i3:uint = 0; i3 < numberOfLeftTopLabels; i3++) {
				var labelBox3:LabelBox = leftTopLabels[i3] as LabelBox;
				
				if(! labelBox3.includeInView) { continue; }
				
				var annotation3:IAnnotation = labelBox3.relatedAnnotation as IAnnotation;
				
				if(annotation3 is Feature) {
					if((annotation3 as Feature).label == "" || !showFeatures || !showFeatureLabels) { continue; }
					
					var featureRenderer3:FeatureRenderer = featuresToRendererMap[annotation3] as FeatureRenderer;
					
					g.moveTo(labelBox3.x + labelBox3.totalWidth, labelBox3.y + labelBox3.totalHeight / 2);
					g.lineTo(featureRenderer3.middlePoint.x, featureRenderer3.middlePoint.y);
				} else if(annotation3 is CutSite) {
					if((annotation3 as CutSite).label == "" || !showCutSites || !showCutSiteLabels) { continue; }
					
					var cutSiteRenderer3:CutSiteRenderer = cutSitesToRendererMap[annotation3] as CutSiteRenderer;
					
					g.moveTo(labelBox3.x + labelBox3.totalWidth, labelBox3.y + labelBox3.totalHeight / 2);
					g.lineTo(cutSiteRenderer3.middlePoint.x, cutSiteRenderer3.middlePoint.y);
				}
			}
			
			var numberOfLeftBottomLabels:uint = leftBottomLabels.length;
			for(var i4:uint = 0; i4 < numberOfLeftBottomLabels; i4++) {
				var labelBox4:LabelBox = leftBottomLabels[i4] as LabelBox;
				
				if(! labelBox4.includeInView) { continue; }
				
				var annotation4:IAnnotation = labelBox4.relatedAnnotation as IAnnotation;
				
				if(annotation4 is Feature) {
					if((annotation4 as Feature).label == "" || !showFeatures || !showFeatureLabels) { continue; }
					
					var featureRenderer4:FeatureRenderer = featuresToRendererMap[annotation4] as FeatureRenderer;
					
					g.moveTo(labelBox4.x + labelBox4.totalWidth, labelBox4.y + labelBox4.totalHeight / 2);
					g.lineTo(featureRenderer4.middlePoint.x, featureRenderer4.middlePoint.y);
				} else if(annotation4 is CutSite) {
					if((annotation4 as CutSite).label == "" || !showCutSites || !showCutSiteLabels) { continue; }
					
					var cutSiteRenderer4:CutSiteRenderer = cutSitesToRendererMap[annotation4] as CutSiteRenderer;
					
					g.moveTo(labelBox4.x + labelBox4.totalWidth, labelBox4.y + labelBox4.totalHeight / 2);
					g.lineTo(cutSiteRenderer4.middlePoint.x, cutSiteRenderer4.middlePoint.y);
				}
			}
		}
		
		private function bpAtPoint(point:Point):uint
		{
	    	var position:Point = parent.localToGlobal(new Point(x, y));
	    	var contentPoint:Point = new Point(point.x - position.x, point.y - position.y);
	    	
			var index:uint = 0;
			
			var angle:Number = 0;
			if((contentPoint.x > _center.x) && (contentPoint.y < _center.y)) { // top right quater
				angle = Math.atan((contentPoint.x - _center.x) / (_center.y - contentPoint.y));
			} else if((contentPoint.x > _center.x) && (contentPoint.y > _center.y)) { // bottom right quater
				angle = Math.PI - Math.atan((contentPoint.x - _center.x) / (contentPoint.y - _center.y));
			} else if((contentPoint.x < _center.x) && (contentPoint.y > _center.y)) { // bottom left quater
				angle = Math.atan((_center.x - contentPoint.x) / (contentPoint.y - _center.y)) + Math.PI;
			} else if((contentPoint.x < _center.x) && (contentPoint.y < _center.y)) {  // top left quater
				angle = 2 * Math.PI - Math.atan((_center.x - contentPoint.x) / (_center.y - contentPoint.y));
			} else if((contentPoint.y == _center.y) && (contentPoint.x > _center.x)) {
				angle = Math.PI / 2;
			} else if((contentPoint.y == _center.y) && (contentPoint.x < _center.x)) {
				angle = 3 * Math.PI / 2;
			}
			
			index = Math.floor(angle * featuredSequence.sequence.length / (2 * Math.PI));
			
			return index;
		}
		
		private function doSelect(start:int, end:int):void
		{
			selectionLayer.select(start, end);
		}
		
		private function doDeselect():void
		{
	    	startSelectionIndex = -1;
	    	endSelectionIndex = -1;
			selectionLayer.deselect();
		}
		
		private function rebuildFeaturesAlignment():void
		{
			featureAlignmentMap = new Dictionary();
			
			if(!_showFeatures || !_featuredSequence || _featuredSequence.features.length == 0) { return; }
			
			var featureAlignment:Alignment = new Alignment(_featuredSequence.features.toArray(), _featuredSequence);
			for(var i:int = 0; i < featureAlignment.rows.length; i++) {
				var featuresRow:Array = featureAlignment.rows[i];
				
				for(var j:int = 0; j < featuresRow.length; j++) {
					var feature:Feature = featuresRow[j] as Feature;
					
					featureAlignmentMap[feature] = i;
				}
			}
		}
			
		private function rebuildORFsAlignment():void
		{
			orfAlignmentMap = new Dictionary();
			
			if(!showORFs || !_orfMapper || _orfMapper.orfs.length == 0) { return; }
			
			var orfAlignment:Alignment = new Alignment(_orfMapper.orfs.toArray(), _featuredSequence);
			for(var k:int = 0; k < orfAlignment.rows.length; k++) {
				var orfsRow:Array = orfAlignment.rows[k];
				
				for(var l:int = 0; l < orfsRow.length; l++) {
					var orf:ORF = orfsRow[l] as ORF;
					
					orfAlignmentMap[orf] = k;
				}
			}
		}
		
		private function tryMoveCaretToPosition(newPosition:int):void
		{
			if(invalidSequence) { return; }
			
			if(newPosition < 0) {
				newPosition = 0;
			} else if(newPosition > featuredSequence.sequence.length) {
				newPosition = featuredSequence.sequence.length;
			}
			
			moveCaretToPosition(newPosition);
		}
		
		private function moveCaretToPosition(newPosition:int):void
		{
			if(newPosition != _caretPosition) {
				doMoveCaretToPosition(newPosition);
				
				dispatchEvent(new CaretEvent(CaretEvent.CARET_POSITION_CHANGED, _caretPosition));
			}
			
			caret.position = _caretPosition;
		}
		
		private function doMoveCaretToPosition(newPosition:int):void
		{
			if(! isValidCaretPosition(newPosition)) {
				throw new Error("Invalid caret position: " + String(newPosition));
			}
			
			_caretPosition = newPosition;
		}
		
		private function isValidCaretPosition(position:int):Boolean
		{
			return isValidIndex(position) || position == featuredSequence.sequence.length;
		}
		
		private function moveCaretLeft():void
		{
			if(_caretPosition == 0) {
				tryMoveCaretToPosition(featuredSequence.sequence.length - 1);
			} else if(_caretPosition > -1 && _caretPosition < _featuredSequence.sequence.length) {
				tryMoveCaretToPosition(_caretPosition - 1);
			}
		}
		
		private function moveCaretRight():void
		{
			if(_caretPosition == _featuredSequence.sequence.length - 1) {
				tryMoveCaretToPosition(0);
			} else if(_caretPosition > -1 && _caretPosition < _featuredSequence.sequence.length - 1) {
				tryMoveCaretToPosition(_caretPosition + 1);
			}
		}
	}
}
