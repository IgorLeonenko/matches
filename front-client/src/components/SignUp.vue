<template>
  <div>
    <form id='user'>
      <p>
        <label for='name'>Name</label>
        <input type='text' v-model='user.name' name='name'></input>
      </p>
      <p>
        <label for='email'>Email</label>
        <input type='email' v-model='user.email' name='email'></textarea>
      </p>
      <p>
        <label for='username'>Username</label>
        <input type="text" v-model='user.username' name="username"></input>
      </p>
      <p>
        <label for='avatar'>Avatar</label>
        <input type="text" v-model='user.avatar' name="avatar"></input>
      </p>
      <p>
        <label for='password'>Password</label>
        <input type="password" v-model='user.password' name="password"></input>
      </p>
      <p>
        <label for='password_confirmation'>Password confirmation</label>
        <input type="password" v-model='user.password_confirmation'
               name="password_confirmation">
        </input>
      </p>
      <button @click='createUser()'>Sign Up</button>
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
