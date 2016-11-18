<template>
  <div>
    <h3>Add team</h3>
    <form id='team'>
      <p>
        <label for='name' v-bind:class="{'error-label': errors['name']}">Name</label>
        <input type='text'
               v-model='newTeam.name' name='name'
               v-bind:class="{'error-field': errors['name']}">
        </input>
        <p v-if="errors['name']" class="error-label">{{errors['name'].toString()}}</p>
      </p>
      <p>
        <span v-show="freeUsersSlots">
          <label for='users' v-bind:class="{'error-label': errors['team_users'] || errors['tournament.tournament_users.user_id']}">Choose user</label>
          <select v-model='userToTeam'>
            <option v-for="user in users" :value="user">
              {{ user.username }}
            </option>
          </select>
          <button type='button' @click='addUserToNewTeam()'>+</button>
          <p v-if="errorUsersLabel" class="error-label">
            {{usersErrors}}
          </p>
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
      tournament: {
        type: Object
      },
      team: {
        type: Object
      }
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
      errors () {
        return this.$store.getters.errors
      },
      usersErrors () {
        if (this.errors['team_users']) {
          return this.errors['team_users'].toString()
        } else if (this.errors['tournament.tournament_users.user_id']) {
          return this.errors['tournament.tournament_users.user_id'].toString()
        }
      },
      errorUsersLabel () {
        if (this.errors['team_users'] || this.errors['tournament.tournament_users.user_id']) {
          return true
        } else {
          return false
        }
      },
      freeUsersSlots () {
        if (this.newTeam.user_ids.length < this.tournament.players_in_team || this.tournament.players_in_team === 0) {
          return true
        } else {
          return false
        }
      },
      selected () {
        return this.newTeam.user_ids
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
          this.$store.dispatch('errors', {'team_users': ''})
          this.newTeam.user_ids.push(this.userToTeam)
        } else {
          this.$store.dispatch('errors', {'team_users': 'User already in list'})
        }
      },
      removeSelectedUser (userId) {
        var index = this.newTeam.user_ids.findIndex(({id}) => id === userId)
        this.newTeam.user_ids.splice(index, 1)
      }
    }
  }
</script>
