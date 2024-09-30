<template>
    <div>
      <!-- Form Section -->
      <form @submit.prevent="submitForm">
        <div>
          <label for="title">Title:</label>
          <input type="text" v-model="title" id="title" required>
        </div>
  
        <div>
          <label for="appointee">Appointee:</label>
          <input type="text" v-model="appointee" id="appointee" required>
        </div>
  
        <div>
          <label for="status">Status:</label>
          <input type="text" v-model="status" id="status" required>
        </div>
  
        <div>
          <label for="last_email">Last Email:</label>
          <input type="date" v-model="last_email" id="last_email" required>
        </div>
  
        <button type="submit" :disabled="loading">Submit</button>
      </form>
  
      <!-- Form submission feedback -->
      <p v-if="formSuccess" class="success-message">Form submitted successfully!</p>
      <p v-if="formError" class="error-message">{{ formError }}</p>
  
      <!-- Email List Section -->
      <div v-if="loading" class="loading">Loading emails...</div>
      <div v-else>
        <h3>Email List:</h3>
        <ul v-if="emails.length">
          <li v-for="email in emails" :key="email.id">
            {{ email.title }} - {{ email.appointee }} - {{ email.status }} - {{ formatDate(email.last_email) }}
          </li>
        </ul>
        <p v-else>No emails found.</p>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        title: '',
        appointee: '',
        status: '',
        last_email: '',
        emails: [],
        loading: false, // Loading state for fetch and form submission
        formSuccess: false,
        formError: '',
      };
    },
    mounted() {
      this.fetchEmails();
    },
    methods: {
      async submitForm() {
        this.formError = ''; // Clear previous errors
        this.formSuccess = false;
        this.loading = true;
  
        try {
          const response = await axios.post('/api/emails', {
            title: this.title,
            appointee: this.appointee,
            status: this.status,
            last_email: this.last_email,
          });
          this.emails.push(response.data);
          this.formSuccess = true;
          this.clearForm();
        } catch (error) {
          if (error.response && error.response.data.errors) {
            this.formError = Object.values(error.response.data.errors).flat().join(', ');
          } else {
            this.formError = 'An error occurred while submitting the form.';
          }
        } finally {
          this.loading = false;
        }
      },
      async fetchEmails() {
        this.loading = true;
        try {
          const response = await axios.get('/api/emails');
          this.emails = response.data;
        } catch (error) {
          console.error('Error fetching emails:', error);
          this.formError = 'Failed to load emails. Please try again later.';
        } finally {
          this.loading = false;
        }
      },
      clearForm() {
        this.title = '';
        this.appointee = '';
        this.status = '';
        this.last_email = '';
      },
      formatDate(date) {
        const options = { year: 'numeric', month: 'long', day: 'numeric' };
        return new Date(date).toLocaleDateString(undefined, options);
      },
    },
  };
  </script>
  
  <style scoped>
  /* Styling for loading, success, and error messages */
  .loading {
    font-size: 1.2rem;
    color: blue;
  }
  
  .success-message {
    color: green;
  }
  
  .error-message {
    color: red;
  }
  </style>
  