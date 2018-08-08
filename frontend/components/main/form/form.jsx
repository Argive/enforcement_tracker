import React from 'react';

class Form extends React.Component {

  constructor(props) {
    super(props);
    this.handleSearch = this.handleSearch.bind(this);
    this.state = {
      zip: '',
      naics: '',
      statutes: []
    };
  }

  handleSearch(e) {
    e.preventDefault();
  }

  render() {

    return(
      <section className="form-container">
        <form onSubmit={this.handleSearch}>
          <h2>Enter your info:</h2>
          <input
            type="number"
            placeholder="ZIP Code"
            maxLength="5"
            />

          <input
            type="text"
            placeholder="NAICS CODE"
            maxLength="5"
            />

          <select name="Statutes" multiple>
            <option value="cwa">Clean Water Act</option>
            <option value="caa">Clean Air Act</option>
            <option value="rcra">Hazardous Waste</option>
            <option value="sdwa">Drinking Water</option>
          </select>

          <input
            type="submit"
            value="Search"
          />

        </form>
      </section>
    );
  }
}

export default Form;
