<template>
  <div>
    <p v-if='errors.length > 0'>{{errors}}</p>
    <h3>Add team</h3>
    <form id='team'>
      <p>
        <label for='name'>Name</label>
        <input type='text' v-model='newTeam.name' name='name'></input>
      </p>
      <p>
        <span v-show="newTeam.user_ids.length < tournament.players_in_team || tournament.players_in_team === 0">
          <label for='users'>Choose user</label>
          <select v-model='userToTeam'>
            <option v-for="user in users" :value="user">
              {{ user.username }}
            </option>
          </select>
          <button type='button' @click='addUserToNewTeam()'>+</button>
        </span>
        <p v-show="tournament.players_in_team > 0">
          Free slots: {{freeSlots}}
        </p>
        <ul>
          <li v-for="user in selected">
            {{ user.username }} <button type='button' @click='removeSelectedUser(user.id)'>X</button>
          </li>
        </ul>
      </p>
      <button type='button' @click='addTeam()'>Add team</button>
    </form>
  </div>
</template>

<script>
  export default {
    name: 'NewTeam',
    props: {
      tournament: {},
      team: {}
    },
    data () {
      return {
        userToTeam: {},
        newTeam: {
          name: '',
          user_ids: []
        }
      }
    },
    computed: {
      selected () {
        return this.newTeam.user_ids
      },
      errors () {
        return this.$store.getters.errors
      },
      freeSlots () {
        return this.tournament.players_in_team - this.newTeam.user_ids.length
      },
      users () {
        return this.$store.getters.users
      }
    },
    methods: {
      reset () {
        this.usersToTeam = []
        this.newTeam = {
          name: '',
          user_ids: []
        }
      },
      addTeam () {
        this.newTeam.user_ids = this.newTeam.user_ids.map((user) => { return user.id })
        this.$store.dispatch('addTeam', [this.tournament.id, this.newTeam])
        this.reset()
      },
      addUserToNewTeam () {
        if (!this.newTeam.user_ids.includes(this.userToTeam)) {
          this.$store.dispatch('errors', '')
          this.newTeam.user_ids.push(this.userToTeam)
        } else {
          this.$store.dispatch('errors', 'User already in list')
        }
      },
      removeSelectedUser (userId) {
        var index = this.newTeam.user_ids.findIndex(({id}) => id === userId)
        this.newTeam.user_ids.splice(index, 1)
      }
    }
  }
</script>
