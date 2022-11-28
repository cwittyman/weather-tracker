import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="location-search"
export default class extends Controller {

  connect() {
    // instance vars
    this.searchInput = this.element.querySelector('.autocomplete');
    this.searchPrev = "";
    this.searchResults = "";
    this.token = document.querySelector('meta[name="csrf-token"]') ? document.querySelector('meta[name="csrf-token"]').content : "";

    var instance = M.Autocomplete.init(this.searchInput, {
      data:{},
      onAutocomplete: this.searchSelect.bind(null, this)
    });
    
    this.searchInput.addEventListener('keyup', this.searchOnChange.bind(null, this));
    this.searchInput.addEventListener('change', this.searchOnChange.bind(null, this));

    //TODO: GEO
  //   $("#detect_gps").click(function(e){
  //     e.preventDefault();
  //     if(!'geolocation' in navigator) {
  //         alert("GPS not available");
  //         return;
  //      }
  //      navigator.geolocation.getCurrentPosition((position) => {
  //          $('#latitude').val(position.coords.latitude.toFixed(2));
  //          $('#longitude').val(position.coords.longitude.toFixed(2));
  //          $('#api_form').submit();
  //      }, (error) => {
  //          alert("An error occurred: " + error.message);
  //      });
  // });

  }

  searchOnChange(self, e) {
    console.log(e.target.value)
    var query = e.target.value;
    if (self.searchPrev == query) {
        return;
    }
    self.searchPrev = query;
    var url = `https://geocoding-api.open-meteo.com/v1/search?name=${encodeURIComponent(query)}`;

    //TODO: re-write using fetch
    $.ajax({
        type: "GET",
        url: url,
        dataType: 'json',
        success: self.searchSuccess.bind(null, self, query),
        error: self.searchError
    });
  }

  searchSuccess(self, query, data){
    console.log('Submission was successful.');
      console.log(data);
      if (query == self.searchPrev) {
        console.log(data)
        self.renderSearchResults(self, data.results||[]);
      }
  }

  searchError(){
    console.log('An error occurred.');
    console.log(data);
    alert(`API error: ${data.responseJSON.reason}`);
  }

  searchSelect(self, selected){
    // console.log(arguments);
    var name = selected.split(",")[0];
    var location = selected.split(",")[1] != null ? selected.split(",")[1].trim()  : "";
    var results = self.searchResults.filter((v, i) => {
      return ((v["name"] == name && v["admin1"] == location));
    })

    self.searchInput.value = "";
    console.log(results);

    if(results.length > 0){
      Turbo.navigator.delegate.adapter.showProgressBar();
      var result = results[0];
      fetch('/locations', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': self.token,
          'Content-Type': 'application/json'
        },
        credentials: 'same-origin',
        body: JSON.stringify({
          "name": selected,
          "lat": result.latitude,
          "lng": result.longitude,
          "timezone": result.timezone,
          "location_id": result.id
        })
      })
      .then (response => response.text())
      .then((html) => {
        Turbo.navigator.delegate.adapter.progressBar.hide();
        Turbo.renderStreamMessage(html);
      })
      .catch((e) => {
        Turbo.navigator.delegate.adapter.progressBar.hide();
        M.toast({html: 'There Was an Error :('})
      });
    }
  }

  renderSearchResults(self, items){
    
    self.searchResults = items;

    var data = {};
    items.forEach(row => {
      var name = row.admin1 ? `${row.name}, ${row.admin1}` : row.name;
      data[name] = "";
    });

    var instance = M.Autocomplete.getInstance(self.searchInput);
    instance.updateData(data);
    instance.open();
  }
  
  // Clean up 
  disconnect() {
    this.searchInput.removeEventListener('keyup', this.searchOnChange);
    this.searchInput.removeEventListener('change', this.searchOnChange);
    this.searchInput = null;
    this.searchResults = null;
  }

}
