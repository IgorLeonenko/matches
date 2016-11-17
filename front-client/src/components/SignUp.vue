<template>
  <div>
    <form id='user'>
      <p>
        <label for='name' v-bind:class="{'error-label': errors['name']}">Name</label>
        <input type='text'
               v-model='user.name' name='name'
               v-bind:class="{'error-field': errors['name']}">
        </input>
        <p v-if="errors['name']" class="error-label">{{errors['name'].toString()}}</p>
      </p>
      <p>
        <label for='email' v-bind:class="{'error-label': errors['email']}">Email</label>
        <input type='email'
               v-model='user.email' name='email'
               v-bind:class="{'error-field': errors['email']}">
        </input>
        <p v-if="errors['email']" class="error-label">{{errors['email'].toString()}}</p>
      </p>
      <p>
        <label for='username' v-bind:class="{'error-label': errors['username']}">Username</label>
        <input type="text"
               v-model='user.username' name="username"
               v-bind:class="{'error-field': errors['username']}">
        </input>
        <p v-if="errors['username']" class="error-label">{{errors['username'].toString()}}</p>
      </p>
      <p>
        <label for='avatar'>Avatar</label>
        <input type="text" v-model='user.avatar' name="avatar"></input>
      </p>
      <p>
        <label for='password' v-bind:class="{'error-label': errors['password']}">Password</label>
        <input type="password"
               v-model='user.password' name="password"
               v-bind:class="{'error-field': errors['password']}">
        </input>
        <p v-if="errors['password']" class="error-label">{{errors['password'].toString()}}</p>
      </p>
      <p>
        <label for='password_confirmation' v-bind:class="{'error-label': errors['password_confirmation']}">Password confirmation</label>
        <input type="password"
               v-model='user.password_confirmation' name="password_confirmation"
               v-bind:class="{'error-field': errors['password_confirmation']}">
        </input>
        <p v-if="errors['password_confirmation']" class="error-label">{{errors['password_confirmation'].toString()}}</p>
      </p>
      <button type='button' @click='createUser()'>Sign Up</button>
    </form>
  </div>
</template>

<script>
  export default {
    name: 'NewUser',
    data () {
      return {
        user: {
          name: '',
          email: '',
          username: '',
          avatar: '',
          password: '',
          password_confirmation: ''
        }
      }
    },
    computed: {
      errors () {
        return this.$store.getters.errors
      }
    },
    methods: {
      createUser () {
        this.$store.dispatch('createUser', this.user)
      }
    }
  }
</script>

<style scoped>
  #user {
    text-align: left;
  }
</style>
