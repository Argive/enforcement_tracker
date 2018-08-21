import React from 'react';

class Form extends React.Component {

  constructor(props) {
    super(props);
  }


  render() {

    return(
      <section className="main">
        <h1>Hello, I am the Argive Enforcement API.</h1>
        <h1>If viewing in a browser, I recommend using <a href="https://chrome.google.com/webstore/detail/jsonview/chklaanhfefbnpoihckbnefhakgolnmc?hl=en">JSON View</a>.</h1>
        <h1>Here are some things you can try:</h1>
        <ul>
          Summarize things:
            <li><a href="api/v1/facilities/summarize"> api/v1/facilities/summarize</a></li>
            <li><a href="api/v1/inspections/summarize"> api/v1/inspections/summarize</a></li>
            <li><a href="api/v1/enforcements/summarize"> api/v1/enforcements/summarize</a></li>
          <br/>
          Search and filter things:
            <li><a href="api/v1/facilities?name=Texaco"> api/v1/facilities?name=Texaco</a></li>
            <li><a href="api/v1/facilities?state=CA"> api/v1/facilities?state=CA</a></li>
            <li><a href="api/v1/facilities?inspection_count_min=10&inspection_count_max=15"> api/v1/facilities?inspection_count_min=10&inspection_count_max=15</a></li>
            <li><a href="api/v1/facilities?fines_min=1000&fines_max=10000"> api/v1/facilities?fines_min=1000&fines_max=10000</a></li>

          <br/>
          View everything:
            <li><a href="api/v1/facilities"> api/v1/facilities</a></li>
            <li><a href="api/v1/facilities/page/2"> api/v1/facilities/page/2</a></li>

        </ul>
      </section>
    );
  }
}

export default Form;
