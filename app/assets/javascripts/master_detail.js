var MDTable = (function(){
	var rowCount = 0;
	var rowBackground = ['#f9f9f9','#fff'];

	var keyCells = function(row, key){
		return _.filter($(row).children().toArray(),
		 		function(e, i){ return _.contains(key, i); });
	};

	var keyVal = function(row, key){
		return _.chain($(row).children().toArray())
				.filter(function(e, i){ return _.contains(key, i); })
				.map(function(e){ return e.textContent; })
				.value();
	};

	var masterEquals = function(a, b, key){
		return _.isEqual(keyVal(a, key), keyVal(b, key));
	};

	var transformRow = function(row, key){
		_.each(keyCells(row, key), function(cell){
			$(cell).children().first().css('visibility', 'hidden');
			$(cell).css('border-width', '0px 1px');
		});
	};

	var transformFirstRow = function(row, key){
		rowCount++;

		_.each(keyCells(row, key), function(cell){
			$(cell).css('border-width', '1px 1px 0px 1px');
		});
	};

	var create = function(selector, key){
		var rows = $(selector + ' tr').toArray();
		_.each(rows, function(row, i, rows){
			if(masterEquals(row, rows[i+1]) && (i === 0 || !masterEquals(row, rows[i-1], key))){
				transformFirstRow(row, key);
			}

			if(i > 0 && masterEquals(row, rows[i-1], key)){
				transformRow(row, key);
			}

			_.each($(row).children(), function(cell){
				$(cell).css('background-color', rowBackground[(rowCount - 1) % 2]);
			});
		});
	}

	return {
		'create': create
	}
 
})();